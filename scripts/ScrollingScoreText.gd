extends Node2D

export var points = 10000

func _ready():
	$Label.text = str(points)


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
