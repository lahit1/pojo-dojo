class_name Weapon

const weapons: Dictionary[Type, PackedScene] = {
	Type.C4SMG04: preload("res://scenes/weapons/4smg04/4smg04.tscn")
}

enum Type {
	C4SMG04
}
