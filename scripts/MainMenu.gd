extends Node2D
func _on_StartGame_button_up():
	var error = get_tree().change_scene("res://scenes/Main.tscn")
	if error != OK:
		print("An error occurred while changing the scene")