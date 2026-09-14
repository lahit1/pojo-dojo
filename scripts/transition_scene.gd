class_name TransitionScene
extends Node2D

@export var scene_node: Node

@export var background_anim_player: AnimationPlayer:
	set(new):
		if background_anim_player:
			background_anim_player.animation_finished.disconnect(_on_animation_finished)
		background_anim_player = new
		background_anim_player.animation_finished.connect(_on_animation_finished)


func _ready() -> void:
	SceneManager.set_scene(
		SceneManager.SceneT.Selector
	)

func _process(_delta: float) -> void:
	if SceneManager.queued_scene != null:
		if background_anim_player:
			if !background_anim_player.is_playing():
				background_anim_player.play("ANIM_OUT")
		else:
			_notify_scene_change()


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ANIM_OUT":
		_notify_scene_change()
	elif anim_name == "ANIM_IN":
		pass

func _notify_scene_change():
	if SceneManager.current_scene != null:
		scene_node.remove_child(SceneManager.current_scene)
	if SceneManager.queued_scene != null:
		scene_node.add_child(SceneManager.queued_scene)
		SceneManager.emit_to_scene_changed_signal(
			SceneManager.current_scene,
			SceneManager.queued_scene
		)
		SceneManager.current_scene = SceneManager.queued_scene
		SceneManager.current_scene_type = SceneManager.queued_scene_type
		SceneManager.queued_scene = null
	if background_anim_player:
		background_anim_player.play("ANIM_IN")
