extends Node

const _KEY_INSTRUCTIONS_TEXT = \
"""Press any key to start
Press %s to quit"""

func _ready():
	var quit_events = InputMap.get_action_list("cancel")
	var quit_key = quit_events[0]

	$Path2D/PathFollow2D/Node2D/title_container/any_key_to_continue.text = \
			_KEY_INSTRUCTIONS_TEXT % quit_key.as_text()

func _input(event):
	if not $AnimationPlayer.is_playing() and (event is InputEventKey) \
			and event.pressed:
		if event.is_action_pressed("cancel"):
			get_tree().quit()
		else:
			get_tree().set_input_as_handled()
			get_tree().change_scene_to(preload("res://rink.tscn"))