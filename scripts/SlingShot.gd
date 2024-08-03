extends StaticBody2D

export var slingshot_strength = 300
export var points = 1000
export var slingshot_direction = Vector2.UP

func get_slingshot_direction():
	return transform.basis_xform(slingshot_direction).normalized()
