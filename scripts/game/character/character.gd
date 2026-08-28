class_name Character


static var characters: Dictionary[int, Character] = {
	Character.Type.C12: Character.new(
		preload("res://scenes/characters/c12.tscn"),
		preload("res://sprites/characters/c12.tres"),
		preload("res://sprites/characters/c12_prev.tres")
	)
}

var scene: PackedScene
var base_sprite: SpriteFrames
var preview: Texture

func _init(
	_scene: PackedScene,
	_base_sprite: SpriteFrames,
	_preview: Texture
) -> void:
	scene = _scene
	base_sprite = _base_sprite
	preview = _preview


enum Type {
	C12
}
