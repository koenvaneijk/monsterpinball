extends Node2D

export var rotation_speed = 5.0
export var friction = 0.98
export var bounce_force = 200.0
export var max_scale = 1.0
export var min_scale = 0.2

onready var spinner = $KinematicBody2D
onready var collision_shape = $KinematicBody2D/CollisionShape2D

var current_speed = 0.0
var current_rotation = 0.0

func _ready():
	spinner.connect("body_entered", self, "_on_body_entered")

func _process(delta):
	# Update rotation
	current_rotation += current_speed * delta
	current_rotation = fmod(current_rotation, 2 * PI)
	
	# Calculate scale based on rotation
	var scale_factor = (cos(current_rotation) + 1) / 2
	var current_scale = lerp(min_scale, max_scale, scale_factor)
	
	# Apply rotation and scale
	spinner.scale = Vector2(1, current_scale)
	spinner.rotation = current_rotation
	
	# Update collision shape
	collision_shape.scale = Vector2(1, 1 / current_scale)
	
	# Apply friction
	current_speed *= friction

func _on_body_entered(body):
	var overlap_points = spinner.get_overlapping_areas()
	if overlap_points.size() > 0:
		var impact_point = overlap_points[0].global_position
		var impact_vector = impact_point - spinner.global_position
		var impact_direction = impact_vector.normalized()
		
		# Calculate torque based on impact point
		var torque = impact_direction.cross(Vector2.RIGHT) * bounce_force
		
		# Apply torque to current speed
		current_speed += torque * rotation_speed


func _on_KinematicBody2D_body_exited(body):
	print(body)
	var overlap_points = spinner.get_overlapping_areas()
	print(overlap_points)
	if overlap_points.size() > 0:
		var impact_point = overlap_points[0].global_position
		var impact_vector = impact_point - spinner.global_position
		var impact_direction = impact_vector.normalized()
		
		# Calculate torque based on impact point
		var torque = impact_direction.cross(Vector2.RIGHT) * bounce_force
		
		# Apply torque to current speed
		current_speed += torque * rotation_speed
