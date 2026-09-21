class_name Weapons

static var weapons: Dictionary[WeaponData.Type, WeaponData] = {
	WeaponData.Type.C4SMG04: WeaponData.new(
		preload("res://scenes/weapons/4smg04/4smg04.tscn")
	),
	WeaponData.Type.C1REVOLVER01: WeaponData.new(
		preload("res://scenes/weapons/1revolver01/1revolver01.tscn")
	),
	WeaponData.Type.C5AASULT_RIFFLE05: WeaponData.new(
		preload("res://scenes/weapons/5AssaultRifle05/5assault_riffle5.tscn")
	),
	WeaponData.Type.C7AASULT_RIFFLE07: WeaponData.new(
		preload("res://scenes/weapons/7assoult_rifle07/7Assoultrifle07.tscn")
	),
	WeaponData.Type.C5EXPLOSIVE05: WeaponData.new(
		preload("res://scenes/weapons/5Explosive05/5Explosive05.tscn")
	),
	WeaponData.Type.C4EXPLOSIVE04: WeaponData.new(
		preload("res://scenes/weapons/4explosive04/4Explosive04.tscn")
	),
	WeaponData.Type.C3PISTOL03: WeaponData.new(
		preload("res://scenes/weapons/3pistol03/3pistol03.tscn")
	),
	WeaponData.Type.C7PISTOL07: WeaponData.new(
		preload("res://scenes/weapons/7pistol07/7pistol07.tscn")
	),
	WeaponData.Type.C6SMG06: WeaponData.new(
		preload("res://scenes/weapons/6smg06/6smg06.tscn")
	)
}
