class_name CameraAligner
extends Camera2D

@export var char1: Node2D
@export var char2: Node2D

@export_group("Zoom Settings")

## Zoom level when far apart
@export var min_zoom: Vector2 = Vector2(1, 1)

## Zoom level when close together
@export var max_zoom: Vector2 = Vector2(3, 3)

## Distance at which camera reaches min_zoom
@export var max_distance: float = 1000.0

## Smoothness factor for tracking
@export var smooth_speed: float = 5.0

func _ready() -> void:
	if is_instance_valid(char1) and is_instance_valid(char2):
		position = (char1.position + char2.position) / 2.0
	elif is_instance_valid(char1):
		position = char1.position
	elif is_instance_valid(char2):
		position = char2.position

func _process(delta: float) -> void:
	if is_instance_valid(char1) and is_instance_valid(char2):
		align_camera(delta)
	elif is_instance_valid(char1):
		position = position.lerp(char1.position, smooth_speed * delta)
	elif is_instance_valid(char2):
		position = position.lerp(char2.position, smooth_speed * delta)


func align_camera(delta: float) -> void:
	# Center position between characters
	var target_position: Vector2 = (char1.position + char2.position) / 2.0
	position = position.lerp(target_position, smooth_speed * delta)
	
	# Calculate required zoom based on distance
	var distance: float = char1.position.distance_to(char2.position)
	var t: float = clamp(distance / max_distance, 0.0, 1.0)
	
	# Interpolate between close-up (max_zoom) and far-away (min_zoom)
	var target_zoom: Vector2 = max_zoom.lerp(min_zoom, t)
	zoom = zoom.lerp(target_zoom, smooth_speed * delta)
