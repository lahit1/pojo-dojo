class_name Utils

static func lerp_movement(src: Vector2, dst: Vector2, weight: float, delta: float) -> Vector2:
	var smoothed_weight = 1.0 - exp(-weight * delta)
	return src.lerp(dst, smoothed_weight)
