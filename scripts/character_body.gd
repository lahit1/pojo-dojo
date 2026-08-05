class_name CharacterNode
extends CharacterBody2D

@export var speed: float = 300.0
@export var acceleration: float = 12.0
@export var friction: float = 15.0
@export var jump_velocity: float = -300.0
@export var max_jumps: int = 2

@export var animation_sprite: AnimatedSprite2D
@export var node_animator: AnimationPlayer
@export var drop_point: Marker2D
@export var weapon_place_holder: Node2D

var move_direction: float = 0.0
var jump_count: int = 0

var current_weapon: WeaponNode

@export_range(0, 100, 1, "suffix:kg") var mass: float = 1

@export_range(0.0, 1.0, 0.01) var shooting_backwards_speed_multiplier: float = 0.5
var is_shooting: bool = false

@export_group("Weapon Rotation")
@export var weapon_rotation_smoothing: float = 15.0
@export var min_aim_distance: float = 10.0
@export var scale_flip_deadzone: float = 5.0
@export_range(0.0, 180.0, 0.1, "suffix:°") var max_weapon_angle: float = 45.0

# Mermi yönü için hesaplanan hedef yön (lerp'ten bağımsız)
var _current_aim_direction: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0

	var effective_speed = speed
	if is_shooting and current_weapon and move_direction != 0:
		var weapon_dir = sign(weapon_place_holder.scale.x) if weapon_place_holder else 1.0
		if sign(move_direction) != weapon_dir:
			effective_speed *= shooting_backwards_speed_multiplier

	var target_velocity_x = move_direction * effective_speed
	var weight = acceleration if move_direction != 0 else friction
	
	var current_vel = Vector2(velocity.x, 0)
	var target_vel = Vector2(target_velocity_x, 0)

	velocity.x = Utils.lerp_movement(current_vel, target_vel, weight, delta).x

	if abs(velocity.x) < 0.5 and move_direction == 0:
		velocity.x = 0

	if animation_sprite:
		if is_shooting or move_direction == 0:
			if current_weapon and weapon_place_holder:
				animation_sprite.flip_h = weapon_place_holder.scale.x < 0
				weapon_place_holder.z_index = 1 if weapon_place_holder.scale.x < 0 else 0
		else:
			animation_sprite.flip_h = move_direction < 0
			weapon_place_holder.z_index = 1 if move_direction < 0 else 0

	_update_animations()

	move_and_slide()

func set_move_direction(dir: float) -> void:
	move_direction = dir

func jump() -> void:
	if is_on_floor() or jump_count < max_jumps:
		if not is_on_floor() and jump_count == 0:
			jump_count = 1

		velocity.y = jump_velocity
		jump_count += 1

func apply_external_velocity(deltaV: Vector2) -> void:
	velocity += deltaV

func apply_external_impulse(momentum: Vector2):
	velocity += momentum / mass

func _update_animations() -> void:
	if is_on_floor():
		if abs(velocity.x) < 10.0 and move_direction == 0:
			_play_animation("idle")
		else:
			# Ateş ederken silahın baktığı yönün tersine mi gidiyor?
			if is_shooting and current_weapon and weapon_place_holder and abs(velocity.x) > 10.0:
				if sign(velocity.x) != sign(weapon_place_holder.scale.x):
					_play_animation("reverse_walk")
				else:
					_play_animation("walk")
			else:
				_play_animation("walk")
	else:
		if velocity.y < 0:
			_play_animation("jump")
		else:
			_play_animation("fall")

func _play_animation(anim_name: String) -> void:
	if animation_sprite and animation_sprite.animation != anim_name:
		animation_sprite.play(anim_name)

	if node_animator and node_animator.current_animation != anim_name:
		node_animator.play(anim_name)

func drop_weapon():
	if not current_weapon: return
	current_weapon.drop.call_deferred()

func shoot():
	if current_weapon:
		current_weapon.shoot(_current_aim_direction)

# ============================================
# SİLAH ROTASYONU
# ============================================

func aim_weapon_at(target_global_pos: Vector2, delta: float) -> void:
	if not current_weapon or not weapon_place_holder:
		return
	
	var barrel := current_weapon.barrel
	if not barrel:
		return
	
	# Scale kararını holder'dan ver (barrel zıplamasın diye)
	var to_mouse_holder := target_global_pos - weapon_place_holder.global_position
	
	if to_mouse_holder.x > scale_flip_deadzone:
		weapon_place_holder.scale.x = 1.0
	elif to_mouse_holder.x < -scale_flip_deadzone:
		weapon_place_holder.scale.x = -1.0
	
	# Barrel'den hedefe vektör
	var barrel_pos := barrel.global_position
	var to_target := target_global_pos - barrel_pos
	var dist := to_target.length()
	
	# Mermi yönünü HER ZAMAN güncelle (deadzone'da bile)
	# Böylece shoot() çağrıldığında en güncel yön kullanılır
	if dist >= 0.01:
		_current_aim_direction = to_target.normalized()
	
	# Deadzone: mouse çok yakınsa görsel rotasyonu değiştirme
	if dist < min_aim_distance:
		return
	
	# Görsel rotasyon hesabı
	var target_global_angle := to_target.angle()
	var parent_angle := (weapon_place_holder.get_parent() as Node2D).global_rotation
	var base_angle := parent_angle
	if weapon_place_holder.scale.x < 0:
		base_angle += PI
	
	var local_angle := angle_difference(base_angle, target_global_angle)
	var max_angle_rad := deg_to_rad(max_weapon_angle)
	var clamped_angle := clampf(local_angle, -max_angle_rad, max_angle_rad)
	
	# Yumuşatma (sadece görsel)
	var t := clampf(weapon_rotation_smoothing * delta, 0.0, 1.0)
	weapon_place_holder.rotation = lerp_angle(weapon_place_holder.rotation, clamped_angle, t)


func reset_weapon_rotation(delta: float) -> void:
	if not current_weapon or not weapon_place_holder:
		return
	
	if move_direction > 0.01:
		weapon_place_holder.scale.x = 1.0
	elif move_direction < -0.01:
		weapon_place_holder.scale.x = -1.0
	
	var t := clampf(weapon_rotation_smoothing * delta, 0.0, 1.0)
	weapon_place_holder.rotation = lerp_angle(weapon_place_holder.rotation, 0.0, t)
	
	# Hareket yönünde ateş edilebilir diye aim direction'ı güncelle
	if move_direction > 0.01:
		_current_aim_direction = Vector2.RIGHT
	elif move_direction < -0.01:
		_current_aim_direction = Vector2.LEFT
