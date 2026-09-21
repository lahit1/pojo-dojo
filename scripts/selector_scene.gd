@tool
extends Node

@export_group("Player 1", "player1_")
var player1_t: CharacterData.Type
@export var player1: AnimatedSprite2D
@export var player1_next_sprite_button: BaseButton
@export var player1_prev_sprite_button: BaseButton
@export var player1_ready_button: BaseButton

@export_group("Player 2", "player2_")
var player2_t: CharacterData.Type
@export var player2: AnimatedSprite2D
@export var player2_next_sprite_button: BaseButton
@export var player2_prev_sprite_button: BaseButton
@export var player2_ready_button: BaseButton

var node2ctype: Dictionary[Node, CharacterData.Type] = {}

func _ready() -> void:
	player2.flip_h = true

	select(0, CharacterData.Type.C12)

	select(1, CharacterData.Type.C12)

	player1_next_sprite_button.pressed.connect(
		func():
			select(0, player1_t + 1)
			pass
	)
	player1_prev_sprite_button.pressed.connect(
		func():
			select(0, player1_t - 1)
			pass
	)
	player1_ready_button.toggled.connect(
		_notify_readiness
	)

	player2_next_sprite_button.pressed.connect(
		func():
			select(1, player2_t + 1)
			pass
	)
	player2_prev_sprite_button.pressed.connect(
		func():
			select(1, player2_t - 1)
			pass
	)
	player2_ready_button.toggled.connect(
		_notify_readiness
	)

func select(n: int, ctype: CharacterData.Type):
	ctype = (ctype % CharacterData.Type._COUNT + CharacterData.Type._COUNT) % CharacterData.Type._COUNT
	var sprite2d: AnimatedSprite2D = player1 if n == 0 else player2;
	var character_data := Characters.get_character_data(ctype)
	var sprite_frames := character_data.base_sprite

	sprite2d.sprite_frames = sprite_frames
	sprite2d.play("idle")

	if n == 0:
		player1_t = ctype
		GameManager.character1 = character_data
	else:
		player2_t = ctype
		GameManager.character2 = character_data

var readiness: int = 0
func _notify_readiness(v: bool):
	readiness += 1 if v else -1
	if readiness == 2:
		SceneManager.set_scene(SceneManager.SceneT.Game)
		pass
