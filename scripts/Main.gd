extends Node2D

var ball_scene = preload("res://scenes/Ball.tscn")

onready var score_label = $HUD/ScoreLabel
onready var balls_label = $HUD/BallsLabel
onready var ball_start = $Table/BallStart

func _ready():
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, 800)
	
	# Reset game
	GameState.balls_left = 3
	GameState.score = 0
	
	update_hud()
	spawn_ball()

func _process(delta):
	if Input.is_action_just_pressed("launch_ball") and $Ball == null:
		spawn_ball()

func update_hud():
	score_label.text = "Score: "+ GameState.get_formatted_score()
	balls_label.text = "Balls: %d" % GameState.balls_left

func spawn_ball():
	if GameState.balls_left > 0:
		var ball = ball_scene.instance()
		ball.position = ball_start.position
		add_child(ball)
		GameState.balls_left -= 1
		update_hud()

func _on_ball_lost():
	if GameState.balls_left > 0:
		spawn_ball()
	else:
		get_tree().change_scene("res://scenes/GameOver.tscn")

func add_score(points):
	GameState.score += points
	update_hud()

