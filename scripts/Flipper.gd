extends KinematicBody2D


export var flip_angle = 70
export(String, "left", "right") var flipper_side

var rest_angle = 0
var current_angle = 0
var flipping = false

func _ready():
	rest_angle = rotation_degrees
	if flipper_side == "left":
		flip_angle = 110

func _physics_process(delta): 
	if Input.is_action_pressed("flip_" + flipper_side):
		flipping = true
		current_angle = lerp(current_angle, flip_angle, 0.4)
	else:
		flipping = false
		current_angle = lerp(current_angle, rest_angle, 0.4)
	
	rotation_degrees = current_angle
