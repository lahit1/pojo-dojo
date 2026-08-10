extends Node

var character: CharacterNode

@export var body: RigidBody2D

@export var max_interaction_damage: float = 80
@export var min_interaction_damage: float = 45

# Zero for no explosion
@export var max_explosive_damage: float = 0
@export var min_explosive_damage: float = 0

func _ready() -> void:
		body.contact_monitor = true
		body.max_contacts_reported = max(body.max_contacts_reported, 4)

		body.body_entered.connect(
			func(collider: Node):
				if character == collider: return
				
				if collider.is_in_group("damagable") and collider.has_method("take_damage"):
					collider.take_damage(
						randf_range(min_interaction_damage, max_interaction_damage)
					)
		)
