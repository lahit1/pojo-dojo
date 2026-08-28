class_name Character


static var characters: Dictionary[int, Character] = {
	Character.Type.C12: Character.new(
		preload("res://scenes/characters/c12.tscn"),
		preload("res://sprites/characters/c12.tres")
	),
	Character.Type.CPUNPKIN: Character.new(
		preload("res://scenes/characters/punpkin.tscn"),
		preload("res://sprites/characters/punpkin.tres")
	)
}

var scene: PackedScene
var base_sprite: SpriteFrames

func _init(
	_scene: PackedScene,
	_base_sprite: SpriteFrames,
) -> void:
	scene = _scene
	base_sprite = _base_sprite


enum Type {
	C12,
	CPUNPKIN,
	_COUNT
}
