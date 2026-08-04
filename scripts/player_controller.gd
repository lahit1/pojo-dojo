class_name PlayerController
extends Node

var character: CharacterNode
@export var camera: Camera2D

@export_group("Action Mapping")
@export var left_movement_action: StringName = "move_left"
@export var right_movement_action: StringName = "move_right"
@export var jump_movement_action: StringName = "jump"
@export var drop_weapon_action: StringName = "drop"
@export var shoot_weapon_action: StringName = "shoot"

func _ready() -> void:
	# Eğer character script içinden atanmadıysa, otomatik olarak ebeveyni kontrol et
	if not character and get_parent() is CharacterBody2D:
		character = get_parent() as CharacterBody2D

func _process(delta: float) -> void:
	align_weapon()

func _physics_process(_delta: float) -> void:
	if not character:
		return

	# StringName doğrudan Input sistemiyle çalışır
	var direction := Input.get_axis(left_movement_action, right_movement_action)
	character.set_move_direction(direction)

	if Input.is_action_just_pressed(jump_movement_action):
		character.jump()
	
	if Input.is_action_just_pressed(drop_weapon_action):
		character.drop_weapon()
	
	if Input.is_action_pressed(shoot_weapon_action):
		character.shoot()

func align_weapon() -> void:
	if not character or not character.current_weapon: return

	var weapon_place_holder := character.weapon_place_holder
	var weapon = character.current_weapon
	var mouse_pos: Vector2 = weapon_place_holder.get_global_mouse_position()

	# 1. Placeholder pivotundan fareye giden vektör ve mesafe
	var to_mouse: Vector2 = mouse_pos - weapon_place_holder.global_position
	var dist: float = to_mouse.length()

	# Fare çok yakınsa sıfıra bölünme ve titremeyi önlemek için çık
	if dist < 5.0:
		return

	# 2. Namlu ucunun (barrel) weapon_place_holder'a göre yerel pozisyonu
	var barrel_local_pos: Vector2 = weapon_place_holder.to_local(weapon.barrel.global_position)
	
	# 3. Temel hedef açı
	var target_global_angle: float = to_mouse.angle()
	
	# 4. Y ofseti kadar olan açı düzeltmesi (Trigonometrik paralaks)
	if dist > abs(barrel_local_pos.y):
		# Godot Y-down çalıştığı için -asin(...) kullanılır
		var correction: float = asin(barrel_local_pos.y / dist)
		target_global_angle -= correction

	# 5. Ebeveyn açısına göre yerel açı farkı
	var parent_global_angle: float = weapon_place_holder.get_parent().global_rotation
	var local_angle: float = angle_difference(parent_global_angle, target_global_angle)
	
	# 6. Clamp (-45° ile +45° arası)
	var max_angle: float = deg_to_rad(45.0)
	weapon_place_holder.rotation = clampf(local_angle, -max_angle, max_angle)
