extends RigidBody2D

var scrolling_score_text_scene = preload("res://scenes/ScrollingScoreText.tscn")

export var initial_velocity = Vector2(0, 200)
export var rotation_speed = 0

var on_ramp = false

func _ready():
	linear_velocity = initial_velocity

func _physics_process(delta):
	if not on_ramp:
		var rotation_amount = linear_velocity.length() * rotation_speed * delta
		var rotation_direction = sign(linear_velocity.cross(Vector2.UP))
		rotate(rotation_direction * rotation_amount)

func _integrate_forces(state):
	if not on_ramp:
		var max_speed = 3000
		if state.linear_velocity.length() > max_speed:
			state.linear_velocity = state.linear_velocity.normalized() * max_speed

func enter_ramp():
	on_ramp = true
	mode = RigidBody2D.MODE_KINEMATIC

func exit_ramp(exit_velocity):
	on_ramp = false
	mode = RigidBody2D.MODE_RIGID
	linear_velocity = exit_velocity

func lost():
	get_node("/root/Main")._on_ball_lost()
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("bumpers"):
		_handle_bumper_collision(body)
	elif body.is_in_group("slingshots"):
		_handle_slingshot_collision(body)

func _handle_bumper_collision(bumper):
	var direction = (global_position - bumper.global_position).normalized()
	apply_impulse(Vector2.ZERO, direction * bumper.bumper_strength)
	_add_score_and_effect(bumper.points, position)

func _handle_slingshot_collision(slingshot):
	var slingshot_direction = slingshot.get_slingshot_direction()
	apply_impulse(Vector2.ZERO, slingshot_direction * slingshot.slingshot_strength)
	_add_score_and_effect(slingshot.points, position)

func _add_score_and_effect(points, effect_position):
	get_node("/root/Main").add_score(points)
	
	var scrolling_score_text = scrolling_score_text_scene.instance()
	scrolling_score_text.points = points
	scrolling_score_text.position = effect_position
	scrolling_score_text.z_index = 10  # Set a higher Z-index value
	get_node("/root/Main").add_child(scrolling_score_text)
