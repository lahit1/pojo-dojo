@tool
extends Node

@export_group("Player 1", "player1_")
var player1_t: Character.Type
@export var player1: AnimatedSprite2D
@export var player1_next_sprite_button: Button
@export var player1_prev_sprite_button: Button

@export_group("Player 2", "player2_")
var player2_t: Character.Type
@export var player2: AnimatedSprite2D
@export var player2_next_sprite_button: Button
@export var player2_prev_sprite_button: Button

var node2ctype: Dictionary[Node, Character.Type] = {}

func _ready() -> void:
	player2.flip_h = true

	select(0, Character.Type.C12)

	select(1, Character.Type.C12)

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

func select(n: int, ctype: Character.Type):
	ctype = (ctype % Character.Type._COUNT + Character.Type._COUNT) % Character.Type._COUNT
	var sprite2d: AnimatedSprite2D = player1 if n == 0 else player2;
	var sprite_frames := Character.characters[ctype].base_sprite

	sprite2d.sprite_frames = sprite_frames
	sprite2d.play("idle")

	if n == 0:
		player1_t = ctype
		GameManager.character1 = Character.characters[ctype]
	else:
		player2_t = ctype
		GameManager.character2 = Character.characters[ctype]
