class_name PlayerController
extends Node

var character: CharacterNode
@export var camera: Camera2D

@export_group("Action Mapping")
@export var left_movement_action: StringName = "move_left"
@export var right_movement_action: StringName = "move_right"
@export var jump_movement_action: StringName = "jump"
@export var drop_weapon_action: StringName = "drop"
@export var melee_attack_action: StringName = "melee_attack"
@export var shoot_weapon_action: StringName = "shoot"

# --- YENİ: Mouse pozisyonunu _process'te cache'le, _physics_process'te kullan ---
var _cached_mouse_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	if not character and get_parent() is CharacterBody2D:
		character = get_parent() as CharacterBody2D

func _process(_delta: float) -> void:
	# get_global_mouse_position() SADECE _process'te güvenli çalışır
	if character and character.weapon_place_holder:
		_cached_mouse_pos = character.weapon_place_holder.get_global_mouse_position()

func _physics_process(_delta: float) -> void:
	if not character:
		return

	var direction := Input.get_axis(left_movement_action, right_movement_action)
	var is_shooting := Input.is_action_pressed(shoot_weapon_action)
	var is_moving: bool = abs(direction) > 0.01
	
	character.is_shooting = is_shooting
	character.set_move_direction(direction)

	if Input.is_action_just_pressed(jump_movement_action):
		character.jump()
	
	if Input.is_action_just_pressed(drop_weapon_action):
		character.drop_weapon()

	if Input.is_action_just_pressed("melee_attack"):
		character.attack_melee()
	
	# Cache'lenmiş mouse pozisyonunu kullan (viewport null hatası olmaz)
	if is_shooting or not is_moving:
		character.aim_weapon_at(_cached_mouse_pos, _delta)
	else:
		character.reset_weapon_rotation(_delta)
	
	if is_shooting:
		character.shoot()
