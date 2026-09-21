extends Node

@export var health = 100

func take_damage(val: float) -> void:
	if health == 0: return
	if health < val:
		val = health
		health = 0
	else:
		health -= val

	if health == 0:
		(
			func():
				get_parent().remove_child(self)
				free()
		).call_deferred()
