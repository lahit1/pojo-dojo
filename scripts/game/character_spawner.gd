@tool
class_name CharacterSpawner
extends Node

var world: WorldNode
@export var camera_aligner: CameraAligner
@export var player_controller1: PlayerController
@export var player_controller2: PlayerController

func _ready() -> void:
	add_child(Marker2D.new())

func request_spawn(character: Node2D):
	if world.spawn_points.is_empty(): return

	var spawn_point_index = 0
	var spawn_point = world.spawn_points[spawn_point_index]
	world.spawn_points.remove_at(spawn_point_index)

	spawn_point.get_parent().add_child.call_deferred(character)
	character.position = spawn_point.position
	spawn_point.queue_free()

	camera_aligner.char2 = camera_aligner.char1
	camera_aligner.char1 = character

	if is_instance_valid(player_controller2) && is_instance_valid(player_controller1):
		player_controller2.character = player_controller1.character

	if is_instance_valid(player_controller1):
		player_controller1.character = character
