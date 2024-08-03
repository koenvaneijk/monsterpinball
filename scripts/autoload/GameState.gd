extends Node


export(int) var balls_left
export(int) var score

var high_score: int = 0

const SAVE_FILE_PATH = "user://highscore.cfg"


func get_formatted_score():
	if score >= 1000:
		return "%0.3f" % (score / 1000.0)
	else:
		return str(score)
		
		
func get_formatted_high_score():
	if high_score >= 1000:
		return "%0.3f" % (high_score / 1000.0)
	else:
		return str(high_score)		

func _ready():
	load_high_score()

func save_high_score():
	if score > high_score:
		high_score = score
		var config = ConfigFile.new()
		config.set_value("Game", "HighScore", high_score)
		config.save(SAVE_FILE_PATH)

func load_high_score():
	var config = ConfigFile.new()
	var error = config.load(SAVE_FILE_PATH)
	if error == OK:
		high_score = config.get_value("Game", "HighScore", 0)
	else:
		print("Error loading high score: ", error)

func update_score(new_score: int):
	score = new_score
	if score > high_score:
		save_high_score()

func get_high_score() -> int:
	return high_score
