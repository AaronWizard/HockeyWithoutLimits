extends Node

func _input(event):
	if not $AnimationPlayer.is_playing() and (event is InputEventKey) \
			and event.pressed:
		if event.is_action_pressed("cancel"):
			get_tree().quit()
		else:
			get_tree().set_input_as_handled()
			get_tree().change_scene_to(preload("res://rink.tscn"))