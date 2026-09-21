class_name WeaponData

var scene: PackedScene

func _init(
	_scene: PackedScene
) -> void:
	scene = _scene

enum Type {
	C3PISTOL03,
	C1REVOLVER01,
	C4SMG04,
	C5EXPLOSIVE05,
	C4EXPLOSIVE04,
	C5AASULT_RIFFLE05,
	C7AASULT_RIFFLE07,
	C7PISTOL07,
	C6SMG06,
}
