extends ColorRect

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("cancel"):
			pass
			#get_tree().paused = false
			#get_tree().change_scene_to(load("res://title.tscn"))
		else:
			get_tree().paused = false
			visible = false