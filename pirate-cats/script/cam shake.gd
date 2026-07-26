extends Camera2D

@export var decay := 8.0
@export var max_offset := Vector2(20, 20)

var shake_strength := 0.0

func apply_shake(strength: float):
	shake_strength = max(shake_strength, strength)

func _process(delta):
	if shake_strength > 0.0:
		offset = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		) * max_offset * shake_strength

		shake_strength = move_toward(shake_strength, 0.0, decay * delta)
	else:
		offset = Vector2.ZERO
