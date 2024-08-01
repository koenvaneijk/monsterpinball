extends StaticBody2D

export var impulse_strength = 300
export var activation_angle = 30

var is_active = false
var initial_rotation

onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var area_2d = $Area2D

func _ready():
	initial_rotation = rotation_degrees
	
	# Set up the collision shape
	var shape = ConvexPolygonShape2D.new()
	shape.points = PoolVector2Array([Vector2(-40, -10), Vector2(40, -10), Vector2(0, 40)])
	collision_shape.shape = shape

	# Connect the area_entered signal
	area_2d.connect("body_entered", self, "_on_Area2D_body_entered")

func _on_Area2D_body_entered(body):
	if body.is_in_group("balls") and not is_active:
		is_active = true
		animation_player.play("activate")
		apply_impulse(body)

func apply_impulse(ball):
	var impulse_direction = Vector2.UP.rotated(rotation)
	ball.apply_central_impulse(impulse_direction * impulse_strength)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "activate":
		is_active = false
		rotation_degrees = initial_rotation
