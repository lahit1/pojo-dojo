class_name CharacterData

var scene: PackedScene
var base_sprite: SpriteFrames
var label: String

func _init(
	_scene: PackedScene,
	_base_sprite: SpriteFrames,
	_label: String
) -> void:
	scene = _scene
	base_sprite = _base_sprite
	label = _label

enum Type {
	C12,
	CPUNPKIN,
	CALIEN,
	CBANDITO,
	CBEETLE_JUIX,
	CDRACULA,
	CFREDDY_K,
	CGANDAL,
	CJOKE,
	CHARLEY_QUEEN,
	CJODA,
	CMARTY_MC,
	CSICARIO,
	CSUORA,
	CTERMINX,
	CTREEP_WOO,
	_COUNT
}
