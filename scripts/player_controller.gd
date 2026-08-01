class_name PlayerController
extends Node

var character: CharacterBody2D

@export_group("Action Mapping")
@export var left_movement_action: StringName = "move_left"
@export var right_movement_action: StringName = "move_right"
@export var jump_movement_action: StringName = "jump"

func _ready() -> void:
	# Eğer character script içinden atanmadıysa, otomatik olarak ebeveyni kontrol et
	if not character and get_parent() is CharacterBody2D:
		character = get_parent() as CharacterBody2D

func _physics_process(_delta: float) -> void:
	if not character:
		return

	# StringName doğrudan Input sistemiyle çalışır
	var direction := Input.get_axis(left_movement_action, right_movement_action)
	character.set_move_direction(direction)

	if Input.is_action_just_pressed(jump_movement_action):
		character.jump()
