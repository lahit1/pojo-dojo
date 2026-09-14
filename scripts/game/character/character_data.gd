class_name CharacterData

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
