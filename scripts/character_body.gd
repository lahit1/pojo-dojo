class_name CharacterNode
extends CharacterBody2D

@export var speed: float = 300.0
@export var acceleration: float = 12.0 # Hızlanma yumuşatması (Daha yüksek = Daha hızlı tepki)
@export var friction: float = 15.0     # Durma/Sürtünme yumuşatması (Daha yüksek = Daha çabuk durma)
@export var jump_velocity: float = -300.0
@export var max_jumps: int = 2 # Toplam zıplama hakkı (2 = Double Jump)

@export var animation_sprite: AnimatedSprite2D
@export var node_animator: AnimationPlayer
@export var drop_point: Marker2D
@export var weapon_place_holder: Node2D

var move_direction: float = 0.0
var jump_count: int = 0

var current_weapon: WeaponNode

@export_range(0, 100, 1, "suffix:kg") var mass: float = 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0

	var target_velocity_x = move_direction * speed
	var weight = acceleration if move_direction != 0 else friction
	
	var current_vel = Vector2(velocity.x, 0)
	var target_vel = Vector2(target_velocity_x, 0)

	velocity.x = Utils.lerp_movement(current_vel, target_vel, weight, delta).x

	if abs(velocity.x) < 0.5 and move_direction == 0:
		velocity.x = 0

	if move_direction != 0 and animation_sprite:
		animation_sprite.flip_h = move_direction < 0

	_update_animations()

	move_and_slide()

# --- Kontrolcü Tarafından Çağrılan Metotlar ---
func set_move_direction(dir: float) -> void:
	move_direction = dir

func jump() -> void:
	if is_on_floor() or jump_count < max_jumps:
		if not is_on_floor() and jump_count == 0:
			jump_count = 1

		velocity.y = jump_velocity
		jump_count += 1

# --- Dış Kuvvet Uygulama Metodu ---
func apply_external_velocity(deltaV: Vector2) -> void:
	velocity += deltaV

func apply_external_impulse(momentum: Vector2):
	velocity += momentum / mass

# --- Animasyon Mantığı ---
func _update_animations() -> void:
	if is_on_floor():
		# lerp kullandığımız için karakter dururken tam 0 olmayabilir, küçük bir tolerans bakıyoruz
		if abs(velocity.x) < 10.0 and move_direction == 0:
			_play_animation("idle")
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
		current_weapon.shoot()
