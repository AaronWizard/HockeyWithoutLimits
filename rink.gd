extends Node

const Puck = preload("res://puck.tscn")
const PuckBurst = preload("res://puck_burst.tscn")
const StickBurst = preload("res://stick_burst.tscn")

const PUCK_GROUP = "puck"
const HEALTH_ANIM_TIME = 0.3
const PARTICLES_REMOVE_DELAY = 0.2

export(int) var puck_speed = 120

export(float) var puck_spawn_max_time = 4
export(float) var puck_spawn_min_time = 0.5
export(float) var puck_spawn_time_speed_step = 0.05

export(int) var max_health = 10

var _puck_time
var _health

func _ready():
	randomize()

	$gui/pause_overlay.visible = false

	_health = max_health
	$gui/health.max_value = max_health
	$gui/health.value = _health

	_puck_time = puck_spawn_max_time
	$puck_spawn_timer.wait_time = puck_spawn_max_time

	$gui/gameover_path.visible = false

func _input(event):
	if not $gui/AnimationPlayer.is_playing() and (event is InputEventKey) \
			and event.pressed:
		var game_over = _health == 0
		var do_pause = event.is_action_pressed("cancel") \
				and not $gui/pause_overlay.visible

		if game_over:
			get_tree().set_input_as_handled()
			get_tree().change_scene_to(load("res://title.tscn"))
		elif do_pause:
			get_tree().set_input_as_handled()
			_pause_game()

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_FOCUS_OUT) and (_health > 0):
		_pause_game()

func _pause_game():
	$gui/pause_overlay.visible = true
	get_tree().paused = true

func _on_puck_spawn_timer_timeout():
	_launch_puck()

func _on_puck_spawn_speed_timer_timeout():
	_puck_time = clamp(_puck_time - puck_spawn_time_speed_step,
			puck_spawn_min_time, puck_spawn_max_time)
	$puck_spawn_timer.wait_time = _puck_time

func _launch_puck():
	$puck_start_path/puck_start.unit_offset = randf()
	$puck_end_path/puck_end.unit_offset = randf()

	var start = $puck_start_path/puck_start.position
	var end = $puck_end_path/puck_end.position

	var velocity = (end - start).normalized() * puck_speed

	var puck = Puck.instance()
	puck.add_to_group(PUCK_GROUP)
	puck.position = start
	puck.velocity = velocity
	add_child(puck)

func _on_net_body_entered( body ):
	if body.is_in_group(PUCK_GROUP):
		$net.do_bump()
		_explode_puck(body.position)
		body.queue_free()

		if _health > 0:
			_health = clamp(_health + 1, 0, max_health)
			_animate_health()

func _on_pass_body_entered( body ):
	if body.is_in_group(PUCK_GROUP):
		body.queue_free()

		if _health != 0:
			$stick.do_damage()

			_health = clamp(_health - 1, 0, max_health)
			if _health == 0:
				_game_over()
			else:
				_animate_health()

func _animate_health():
	$Tween.interpolate_property($gui/health, "value", $gui/health.value,
			_health, HEALTH_ANIM_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not $Tween.is_active():
		$Tween.start()

func _explode_puck(pos):
	pos.y = $net.position.y
	_add_particles(PuckBurst.instance(), pos)

func _add_particles(particles, pos):
	particles.position = pos
	particles.emitting = true
	add_child(particles)
	$Tween.interpolate_callback(particles,
			particles.lifetime + PARTICLES_REMOVE_DELAY, "queue_free")
	if not $Tween.is_active():
		$Tween.start()

func _game_over():
	$stick.visible = false
	$gui/health.visible = false

	$puck_spawn_timer.stop()
	$puck_spawn_speed_timer.stop()

	_add_particles(StickBurst.instance(), $stick.position)

	$gui/gameover_path.visible = true
	if not $gui/AnimationPlayer.is_playing():
		$gui/AnimationPlayer.play("game over")