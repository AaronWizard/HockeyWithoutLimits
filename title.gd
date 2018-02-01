extends Node

func _input(event):
	if not $AnimationPlayer.is_playing() and (event is InputEventKey) \
			and not InputMap.event_is_action(event, "cancel"):
		get_tree().change_scene_to(preload("res://rink.tscn"))