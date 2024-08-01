extends Area2D

export var bumper_strength = 400

func _on_Bumper_body_entered(body):
	if body.is_in_group("balls"):
		var direction = (body.global_position - global_position).normalized()
		body.apply_impulse(Vector2.ZERO, direction * bumper_strength)
		get_node("/root/Main")._on_Bumper_hit()
