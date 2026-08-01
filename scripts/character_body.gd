extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -300.0
@export var max_jumps: int = 2 # Toplam zıplama hakkı (2 = Double Jump)
@export var animation_sprite: AnimatedSprite2D

var move_direction: float = 0.0
var jump_count: int = 0 # Şu ana kadar kaç kez zıplandı?

func _physics_process(delta: float) -> void:
	# 1. Yerçekimi ve Yere Basma Kontrolü
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		# Yere her değdiğinde zıplama sayacını sıfırla
		jump_count = 0

	# 2. Yatay Hareket
	if move_direction != 0:
		velocity.x = move_direction * speed
		if animation_sprite:
			animation_sprite.flip_h = move_direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# 3. Animasyon Yönetimi
	_update_animations()

	# 4. Hareketi Uygula
	move_and_slide()

# --- Kontrolcü Tarafından Çağrılan Metotlar ---

func set_move_direction(dir: float) -> void:
	move_direction = dir

func jump() -> void:
	# Yerdeyse VEYA havada olup henüz zıplama hakkı bitmediyse zıpla
	if is_on_floor() or jump_count < max_jumps:
		# Havada zıplıyorsa ve ilk zıplama yapılmamışsa (örneğin platformdan aşağı düşerken)
		# jump_count'u duruma göre senkronize et
		if not is_on_floor() and jump_count == 0:
			jump_count = 1

		velocity.y = jump_velocity
		jump_count += 1

# --- Animasyon Mantığı ---

func _update_animations() -> void:
	if is_on_floor():
		if move_direction == 0:
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
		# Eğer varsa "double_jump" veya özel animasyonu burada tetikleyebilirsiniz
		animation_sprite.play(anim_name)
