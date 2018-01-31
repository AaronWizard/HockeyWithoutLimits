extends Area2D

func do_bump():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("bump")