extends Area2D

signal switch_activated

var is_active = false
var cooldown_time = 1.0  # Time before the switch can be activated again
var cooldown_timer = 0.0

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _process(delta):
	if not is_active:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			is_active = true

func _on_Switch_body_entered(body):
	if body.is_in_group("balls") and not is_active:
		emit_signal("switch_activated")
		is_active = true
		cooldown_timer = cooldown_time
		$AnimationPlayer.play("activate") # Assuming you have an AnimationPlayer for visual feedback
