class_name GameManager
extends Node

@export var character_spawner: CharacterSpawner
@export var worlds_placeholder: Node
@export var camera: Camera2D

var current_world: WorldNode

func _ready() -> void:
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
