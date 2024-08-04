extends CanvasLayer

func _ready():
	GameState.update_score(GameState.score)
	$ScoreLabel.text = GameState.get_formatted_score()
	$HighScoreLabel.text = GameState.get_formatted_high_score()
	

func _on_Button_button_up():
	var error = get_tree().change_scene("res://scenes/Main.tscn")
	if error != OK:
		print("An error occurred while changing the scene")