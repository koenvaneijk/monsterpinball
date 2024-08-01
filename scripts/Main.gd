extends Node2D

var score = 0
var balls_left = 3
var ball_scene = preload("res://scenes/Ball.tscn")

onready var score_label = $HUD/ScoreLabel
onready var balls_label = $HUD/BallsLabel
onready var ball_start = $Playfield/BallStart

func _ready():
	update_hud()
	spawn_ball()

func _process(delta):
	if Input.is_action_just_pressed("launch_ball") and $Ball == null:
		spawn_ball()

func update_hud():
	score_label.text = "Score: %d" % score
	balls_label.text = "Balls: %d" % balls_left

func spawn_ball():
	if balls_left > 0:
		var ball = ball_scene.instance()
		ball.position = ball_start.position
		add_child(ball)
		balls_left -= 1
		update_hud()

func _on_ball_lost():
	if balls_left > 0:
		spawn_ball()
	else:
		print("Game Over!")

func add_score(points):
	score += points
	update_hud()

func _on_Bumper_hit():
	add_score(10)

func _on_Ramp_completed():
	add_score(50)
