@tool
extends Node2D

@export var vibration_ratio: float = 0.01
@export var timer: Timer

@export var weapon_pop_ratio: float = 0.4
@export var weapon_pop_speed: float = 250

func _process(delta: float) -> void:
	rotation = (randf() - 0.5) * 2 * PI * vibration_ratio
	timer.timeout.connect(
		(func():
			for i in range(0, 2):
				var weapon_dat: WeaponData = Weapons.weapons.values().pick_random()
				var weapon: WeaponNode = weapon_dat.scene.instantiate()
				weapon.body.linear_velocity = Vector2(0, weapon_pop_speed).rotated(
					(randf() - 0.5) * 2 * PI * weapon_pop_ratio - PI
				)
				weapon.position = position
				get_parent().add_child(weapon)
				pass
			get_parent().remove_child(self)
			free()
			pass).call_deferred,
		CONNECT_ONE_SHOT
	)
