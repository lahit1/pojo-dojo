class_name GameManager
extends Node

@export var character_spawner: CharacterSpawner
@export var worlds_placeholder: Node
@export var camera: Camera2D

static var current_world: WorldNode

func _ready() -> void:
	if is_instance_valid(current_world):
		current_world.queue_free()
		current_world = null

	set_world(preload("res://scenes/worlds/world.tscn").instantiate())

	var char1 = Character.characters[Character.Type.C12].instantiate()
	character_spawner.request_spawn(char1)

	var char2 = Character.characters[Character.Type.C12].instantiate()
	character_spawner.request_spawn(char2)

func set_world(world: WorldNode):
	if current_world != null:
		worlds_placeholder.remove_child(current_world)
		current_world.queue_free()
	
	current_world = world
	worlds_placeholder.add_child(current_world)
	
	character_spawner.world = current_world
	camera.limit_left = current_world.camera_limit_left
	camera.limit_top = current_world.camera_limit_top
	camera.limit_right = current_world.camera_limit_right
	camera.limit_bottom = current_world.camera_limit_bottom
	
