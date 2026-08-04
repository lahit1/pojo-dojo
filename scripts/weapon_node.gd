class_name WeaponNode
extends Node2D

@export var body: RigidBody2D
@export var barrel: Marker2D
@export var ammo_director: Marker2D
@export var weapon_throw_velocity_magnitude: float = 300
@export var bullet_speed: float = 2000
@export var bullet_scene: PackedScene
@export var bullet_life_time: float = 2
@export var bullet_cooldown: float = 0.1

@export var magazine_capacity: int = 30
@export var ammo_in_magazine: int = magazine_capacity
@export var magazine_change_duration: float = 2

var current_character: CharacterNode
var direction = 1

var bullet_cooldown_timer: Timer
var magazine_change_timer: Timer

func _ready() -> void:
	body.contact_monitor = true
	body.max_contacts_reported = 4
	body.body_entered.connect(
		func(body: Node):
			if body is CharacterNode and not (body as CharacterNode).current_weapon:
				pickup.call_deferred(body)
	)

	bullet_cooldown_timer = Timer.new()
	bullet_cooldown_timer.wait_time = bullet_cooldown
	bullet_cooldown_timer.one_shot = true
	add_child(bullet_cooldown_timer)

	magazine_change_timer = Timer.new()
	magazine_change_timer.wait_time = magazine_change_duration
	magazine_change_timer.one_shot = true
	magazine_change_timer.timeout.connect(
		func():
			ammo_in_magazine = magazine_capacity
	)

	add_child(magazine_change_timer)

func pickup(character: CharacterNode):
	if current_character != null || character.current_weapon != null: return
	
	get_parent().remove_child.call_deferred(self)
	character.weapon_place_holder.add_child.call_deferred(self)
	character.current_weapon = self
	current_character = character

	body.contact_monitor = false
	body.freeze = true
	body.position = Vector2.ZERO
	body.rotation = 0
	position = Vector2.ZERO
	rotation = 0

func drop():
	if current_character == null || current_character.current_weapon != self: return

	position = current_character.drop_point.global_position - GameManager.current_world.global_position
	body.linear_velocity = weapon_throw_velocity_magnitude * (current_character.drop_point.global_position - current_character.weapon_place_holder.global_position).normalized()
	current_character.weapon_place_holder.remove_child(self)
	GameManager.current_world.add_child(self)

	body.contact_monitor = true
	body.freeze = false

	current_character.current_weapon = null
	current_character = null

func shoot():
	if !bullet_cooldown_timer.is_stopped() or not ammo_in_magazine: return
	bullet_cooldown_timer.start()
	ammo_in_magazine -= 1
	if not ammo_in_magazine:
		magazine_change_timer.start()

	var bullet: RigidBody2D = bullet_scene.instantiate()
	bullet.set_deferred("position", barrel.global_position - GameManager.current_world.global_position)
	bullet.linear_velocity = bullet_speed * (ammo_director.global_position - barrel.global_position).normalized()
	var timer: Timer = Timer.new()

	timer.one_shot = true
	timer.wait_time = bullet_life_time
	timer.timeout.connect(
		func():
			bullet.get_parent().remove_child.call_deferred(bullet)
			bullet.queue_free()
	, CONNECT_ONE_SHOT)

	bullet.add_child(timer)
	GameManager.current_world.add_child.call_deferred(bullet)
	timer.start.call_deferred()
