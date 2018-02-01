extends Node

func _input(event):
	if not $AnimationPlayer.is_playing() and (event is InputEventKey):
		get_tree().change_scene_to(preload("res://rink.tscn"))