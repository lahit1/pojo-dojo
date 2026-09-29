class_name WorldNode
extends Node2D

@export var spawn_points: Array[Marker2D] = []

@export_group("Camera Limits", "camera_limit_")
@export var camera_limit_left: float = -999999
@export var camera_limit_top: float = -999999
@export var camera_limit_right: float = 999999
@export var camera_limit_bottom: float = 999999

@export var max_lucky_blok_dublet_count: int = 1
@export var lucky_blok_spawn_points: Array[Marker2D] = [];
@export var lucky_blok_spawn_timer: Timer
@export var lucky_blok_spawn_min_duration: float = 3
@export var lucky_blok_spawn_max_duration: float = 4

func _ready() -> void:
	reset_lucky_blok_spawn_timer()
	lucky_blok_spawn_timer.timeout.connect(
		(func():
			if WeaponNode.total_instance > max_lucky_blok_dublet_count * 2: return
			var relative_pos = lucky_blok_spawn_points.pick_random().position - position
			var scene: Node2D = preload("res://scenes/lucky_blok.tscn").instantiate()
			scene.position = relative_pos
			add_child(scene)).call_deferred
	)

func notify_weapon_count_changed():
	#if WeaponNode.total_instance < max_lucky_blok_dublet_count * 2:
		reset_lucky_blok_spawn_timer()

func reset_lucky_blok_spawn_timer():
	lucky_blok_spawn_timer.one_shot = true
	lucky_blok_spawn_timer.wait_time = randf_range(lucky_blok_spawn_min_duration, lucky_blok_spawn_max_duration)
	lucky_blok_spawn_timer.start()
