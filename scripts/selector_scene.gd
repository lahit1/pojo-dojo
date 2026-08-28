@tool
extends Node

@export var player1: AnimatedSprite2D
@export var player2: AnimatedSprite2D

var node2ctype: Dictionary[Node, Character.Type] = {}

func _ready() -> void:
	player2.flip_h = true

	select(0, Character.Type.C12)

	select(1, Character.Type.C12)

	#TransitionScene.INSTANCE.set_scene(
		#preload("res://scenes/game.tscn").instantiate()
	#)

func select(n: int, ctype: Character.Type):
	var sprite2d: AnimatedSprite2D = player1 if n == 0 else player2;
	var sprite_frames := Character.characters[ctype].base_sprite

	sprite2d.sprite_frames = sprite_frames
	sprite2d.play("idle")

	if n == 0:
		GameManager.character1 = Character.characters[ctype]
	else:
		GameManager.character2 = Character.characters[ctype]
