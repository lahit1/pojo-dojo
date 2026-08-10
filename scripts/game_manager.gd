class_name GameManager
extends Node

@export var character_spawner: CharacterSpawner
@export var worlds_placeholder: Node
@export var camera: Camera2D
@export var hit_score_placeholder: Node2D

@export_group("Hit Score Indicator", "hit_score_indicator_")
@export var hit_score_indicator_scene: PackedScene
@export var hit_score_indicator_gradient: Gradient
@export var hit_score_indicator_target_motion: Vector2 = Vector2(0, -50)
var hit_score_indicator_rotation_radius: float
@export_range(0, 90, 0.1, "suffix:°") var hit_score_indicator_rotation_radius_degrees: float:
	get():
		return hit_score_indicator_rotation_radius * 180 / PI
	set(val):
		hit_score_indicator_rotation_radius = val * PI / 180

static var current_world: WorldNode
static var current_game: GameManager

func _init() -> void:
	current_game = self

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

func spawn_hit_score(
	score: float, min_score: float, max_score:float, hit_global_position: Vector2
):
	if not hit_score_placeholder or not hit_score_indicator_scene: return

	var score_label: Label = hit_score_indicator_scene.instantiate()
	score_label.position = hit_global_position
	score_label.text = str(int(score))
	score_label.modulate = hit_score_indicator_gradient.sample((score - min_score) / (max_score - min_score))

	var target_position_difference: Vector2 = hit_score_indicator_target_motion.rotated(randf_range(-hit_score_indicator_rotation_radius, hit_score_indicator_rotation_radius))
	var target_position: Vector2 = hit_global_position + target_position_difference

	var tween := score_label.create_tween()

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_ELASTIC)

	tween.tween_property(score_label, "position", target_position, 1.5)
	tween.set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(score_label, "scale", Vector2.ZERO, 1.5)
	tween.finished.connect(
		func():
			score_label.queue_free()
			, CONNECT_ONE_SHOT
	)

	hit_score_placeholder.add_child(score_label)
