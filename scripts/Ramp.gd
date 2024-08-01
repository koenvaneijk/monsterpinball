extends Node2D

signal ball_entered_ramp(ball)
signal ball_exited_ramp(ball)

export var ramp_angle = 30.0  # Angle of the ramp in degrees
export var friction = 0.05    # Friction coefficient of the ramp

onready var entrance = $Entrance
onready var exit = $Exit
onready var path = $Path2D
onready var ball_position = $BallPosition

var ball_on_ramp = null
var ball_velocity = 0.0
var ramp_length = 0.0

func _ready():
	entrance.connect("body_entered", self, "_on_Entrance_body_entered")
	exit.connect("body_entered", self, "_on_Exit_body_entered")
	ramp_length = path.curve.get_baked_length()

func _on_Entrance_body_entered(body):
	if body.is_in_group("balls") and ball_on_ramp == null:
		ball_on_ramp = body
		ball_velocity = body.linear_velocity.length() * cos(deg2rad(ramp_angle))
		body.enter_ramp()
		emit_signal("ball_entered_ramp", body)

func _on_Exit_body_entered(body):
	if body == ball_on_ramp:
		var exit_velocity = Vector2.RIGHT.rotated(path.curve.get_point_position(1).angle()) * ball_velocity
		ball_on_ramp.exit_ramp(exit_velocity)
		ball_on_ramp = null
		emit_signal("ball_exited_ramp", body)
		get_node("/root/Main")._on_Ramp_completed()

func _physics_process(delta):
	if ball_on_ramp:
		move_ball_along_path(delta)

func move_ball_along_path(delta):
	var gravity = 9.8 * 100  # Convert to pixels/sec^2
	var acceleration = gravity * sin(deg2rad(ramp_angle)) - friction * gravity * cos(deg2rad(ramp_angle))
	
	ball_velocity += acceleration * delta
	var distance = ball_velocity * delta
	
	var new_offset = ball_position.offset + distance
	if new_offset > ramp_length:
		ball_on_ramp.global_position = exit.global_position
		_on_Exit_body_entered(ball_on_ramp)
	elif new_offset < 0:
		ball_on_ramp.global_position = entrance.global_position
		var exit_velocity = Vector2.LEFT.rotated(path.curve.get_point_position(0).angle()) * abs(ball_velocity)
		ball_on_ramp.exit_ramp(exit_velocity)
		ball_on_ramp = null
		emit_signal("ball_exited_ramp", ball_on_ramp)
	else:
		ball_position.offset = new_offset
		ball_on_ramp.global_position = ball_position.global_position
