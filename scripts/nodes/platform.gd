extends Node2D

@export var destinations: Array[DestinationMarker2D] = [DestinationMarker2D.new()]

@export var current_destination_index: int = 0
@export var tween_interval: float = 0.5
@export var tween_duration: float = 1.0
var tween: Tween

func _ready() -> void:
	position = Vector2.ZERO
	start_next_tween()

func start_next_tween():
	current_destination_index = (current_destination_index + 1) % destinations.size()
	var destination = destinations[current_destination_index]

	tween = create_tween().set_ease(destination.ease_type).set_trans(destination.transition_type)

	tween.tween_interval(tween_interval)
	tween.tween_property(self, "position", destination.global_position - destinations[0].global_position, destination.tween_duration)
	tween.finished.connect(start_next_tween)
