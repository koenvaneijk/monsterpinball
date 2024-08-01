extends KinematicBody2D

export var flip_strength = 10000
export var flip_angle = 45
export(String, "left", "right") var flipper_side

var rest_angle = 0
var current_angle = 0
var flipping = false

func _ready():
	rest_angle = rotation_degrees
	if flipper_side == "left":
		flip_angle = -flip_angle

func _physics_process(delta): 
	if Input.is_action_pressed("flip_" + flipper_side):
		flipping = true
		current_angle = lerp(current_angle, flip_angle, 0.4)
	else:
		flipping = false
		current_angle = lerp(current_angle, rest_angle, 0.4)
	
	rotation_degrees = current_angle

func _on_Flipper_body_entered(body):
	if body.is_in_group("balls") and flipping:
		print(body)
		body.apply_impulse(Vector2.ZERO, Vector2.UP.rotated(rotation) * flip_strength)
