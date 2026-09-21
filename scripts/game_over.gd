class_name GameOverScene
extends Node

static var winner_dat: CharacterData
static var winner_label: String

@export var sprite: AnimatedSprite2D
@export var label: Label

func _ready() -> void:
	label.text = winner_label
	sprite.sprite_frames = winner_dat.base_sprite
	SceneManager.set_scene(SceneManager.SceneT.GameOver)
	pass

func _input(event: InputEvent) -> void:
	SceneManager.set_scene(
		SceneManager.SceneT.Selector
	)
