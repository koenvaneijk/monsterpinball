extends Node2D

export var points = 10000

func _ready():
	if points >= 1000:
		$Label.text = "%0.3f" % (points / 1000.0)
	else:
		$Label.text = str(points)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
