class_name TransitionScene
extends Node2D

static var INSTANCE: TransitionScene

@export var scene_placeholder: Node

var current_scene: Node

func _init() -> void:
	INSTANCE = self

func _ready() -> void:
	set_scene(
		preload("res://scenes/selector.tscn").instantiate()
	)

func set_scene(scene: Node):
	if current_scene:
		scene_placeholder.remove_child(current_scene)
	current_scene = scene
	scene_placeholder.add_child(scene)
