extends Node2D

var character: CharacterNode

@export var body: RigidBody2D
@export var sprite: Sprite2D

@export var max_interaction_damage: float = 80
@export var min_interaction_damage: float = 45

@export var can_explode: bool = false
@export var max_explosive_damage: float = 2500
@export var min_explosive_damage: float = 2000
@export var explosion_radius: float = 250
@export var explosion_impulse: float = 10000
@export var explosion_particles: GPUParticles2D
var dead: bool = false

func _ready() -> void:
		body.contact_monitor = true
		body.max_contacts_reported = max(body.max_contacts_reported, 4)

		body.body_entered.connect(
			collision_check
		)

func collision_check(collider: CollisionObject2D):
	if dead || \
		(character == collider || body == collider) || \
		!(collider.collision_layer & body.collision_mask) || \
		!(collider.is_in_group("shootable")): return

	dead = true

	body.set_deferred("contact_monitor", false)
	sprite.visible = false

	if collider.is_in_group("damagable") and collider.has_method("take_damage"):
		collider.take_damage(
			randf_range(min_interaction_damage, max_interaction_damage)
		)

	if can_explode:
		trigger_explosition()
	else:
		end_func()

	body.body_entered.disconnect(collision_check)

func trigger_explosition() -> void:
	var space_state = get_world_2d().direct_space_state

	var shape = CircleShape2D.new()
	shape.radius = explosion_radius

	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0.0, body.global_position)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask = body.collision_mask

	var results = space_state.intersect_shape(query)

	if explosion_particles:
		explosion_particles.emitting = true
		explosion_particles.finished.connect(
				end_func,
				CONNECT_DEFERRED
			)

	for hit in results:
		var collider = hit.collider

		var diff: Vector2 = collider.global_position - body.global_position as Vector2
		var distance: float = diff.length()
		var dist_loss_multiplier := ((1 - distance / explosion_radius) ** 2)
		var damage_amount: float = lerp(min_explosive_damage, max_explosive_damage, ((explosion_radius - distance) / explosion_radius) ** 2)

		if collider.is_in_group("damagable") && collider.has_method("take_damage"):
			collider.take_damage(damage_amount *  dist_loss_multiplier)
		if damage_amount > 0 && collider.is_in_group("throwable") && collider.has_method("apply_external_impulse"):
			collider.apply_external_impulse(diff.normalized() * explosion_impulse * dist_loss_multiplier)

func end_func():
	(func():
		get_parent().remove_child(self)
		free()
	).call_deferred()
