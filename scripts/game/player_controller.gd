class_name PlayerController
extends Node

# Konsol bağlantısı değiştiğinde çağrılacak sinyal
signal gamepad_connection_changed(device_id: int, is_connected: bool)

var character: CharacterNode
@export var camera: Camera2D

@export_group("Gamepad Settings")
## Hangi oyun kolunun (joypad) dinleneceğini belirler. Genelde 1. kol 0'dır.
@export var joy_device_id: int = 0
## Analog çubuğun ölü bölge (deadzone) hassasiyeti (ufak dokunuşları yoksaymak için)
@export var joystick_deadzone: float = 0.2

@export_group("Action Mapping")
@export var left_movement_action: StringName = "move_left"
@export var right_movement_action: StringName = "move_right"
@export var jump_movement_action: StringName = "jump"
@export var drop_weapon_action: StringName = "drop"
@export var melee_attack_action: StringName = "melee_attack"
@export var shoot_weapon_action: StringName = "shoot"

# Mouse veya sağ analog pozisyonunu tutacak değişken
var _cached_aim_target: Vector2 = Vector2.ZERO
var _is_gamepad_active: bool = false
var _last_gamepad_aim_dir: Vector2 = Vector2.RIGHT # Analog bırakılınca son bakılan yönü korumak için

func _ready() -> void:
	if not character and get_parent() is CharacterBody2D:
		character = get_parent() as CharacterBody2D

	# Oyun kolu bağlantı sinyaline (takılma/çıkma) bağlan
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	
	# Oyun başlarken hedef konsol ID'si bağlı mı kontrol et
	_check_initial_gamepad()

# Başlangıçta kolun bağlı olup olmadığını kontrol eden fonksiyon
func _check_initial_gamepad() -> void:
	var connected_pads = Input.get_connected_joypads()
	_is_gamepad_active = joy_device_id in connected_pads

# Konsol (Gamepad) takıldığında veya çıkarıldığında tetiklenir
func _on_joy_connection_changed(device: int, connected: bool) -> void:
	# Sadece editörden belirlediğimiz joy_device_id için işlem yapıyoruz
	if device == joy_device_id:
		_is_gamepad_active = connected
		gamepad_connection_changed.emit(device, connected)

func _process(_delta: float) -> void:
	if not character or not character.weapon_place_holder:
		return
		
	if _is_gamepad_active:
		# Konsol bağlıysa Sağ Analog çubuğunu oku (Nişan alma)
		# X ve Y eksenlerini doğrudan cihaz ID'sine göre alıyoruz
		var aim_x := Input.get_joy_axis(joy_device_id, JOY_AXIS_RIGHT_X)
		var aim_y := Input.get_joy_axis(joy_device_id, JOY_AXIS_RIGHT_Y)
		var aim_dir := Vector2(aim_x, aim_y)
		
		# Analog çubuk ölü bölgeden (deadzone) büyükse yönü güncelle
		if aim_dir.length() > joystick_deadzone:
			_last_gamepad_aim_dir = aim_dir.normalized()
			
		# aim_weapon_at pozisyon beklediği için, karakterin uzağında sahte bir pozisyon yaratıyoruz
		_cached_aim_target = character.weapon_place_holder.global_position + (_last_gamepad_aim_dir * 100.0)
	else:
		# Konsol yoksa / çalışmıyorsa fare pozisyonunu kullan (get_global_mouse_position sadece _process'te güvenli)
		_cached_aim_target = character.weapon_place_holder.get_global_mouse_position()

func _physics_process(_delta: float) -> void:
	if not character:
		return

	# Hareket ve diğer tuşlar, Input Map'te hem klavye hem joypad için ayarlandıysa
	# aktif cihaza göre otomatik olarak Godot tarafından algılanacaktır.
	var direction := Input.get_axis(left_movement_action, right_movement_action)
	var is_shooting := Input.is_action_pressed(shoot_weapon_action)
	var is_moving: bool = abs(direction) > 0.01
	
	character.is_shooting = is_shooting
	character.set_move_direction(direction)

	if Input.is_action_just_pressed(jump_movement_action):
		character.jump()
	
	if Input.is_action_just_pressed(drop_weapon_action):
		character.drop_weapon()

	if Input.is_action_just_pressed(melee_attack_action):
		character.attack_melee()
	
	# Cache'lenmiş mouse veya sağ analog hedef pozisyonunu kullan
	if is_shooting or not is_moving:
		character.aim_weapon_at(_cached_aim_target, _delta)
	else:
		character.reset_weapon_rotation(_delta)
	
	if is_shooting:
		character.shoot()
