extends RigidBody2D

export var initial_velocity = Vector2(0, 200)
export var rotation_speed = 0.1

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
	queue_free()
