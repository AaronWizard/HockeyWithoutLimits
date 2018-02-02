extends ColorRect

const _KEY_INSTRUCTIONS_TEXT = \
"""Press %s to quit
Press any other key to continue"""

func _ready():
	var quit_events = InputMap.get_action_list("cancel")
	var quit_key = quit_events[0]

	$VBoxContainer/key_to_continue.text = \
			_KEY_INSTRUCTIONS_TEXT % quit_key.as_text()

func _input(event):
	if visible and (event is InputEventKey) and event.pressed:
		if event.is_action_pressed("cancel"):
			get_tree().paused = false
			get_tree().change_scene_to(load("res://title.tscn"))
		else:
			get_tree().paused = false
			visible = false