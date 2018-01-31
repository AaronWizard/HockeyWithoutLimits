extends KinematicBody2D

export(int) var speed = 140



func _ready():
	$hit_particles.emitting = false
	$particle_timer.wait_time = $hit_particles.lifetime

func _process(delta):
	pass

func _physics_process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	velocity *= speed * delta

	move_and_collide(velocity)

func do_bump():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("bump")

func do_damage():
	if not $hit_particles.emitting:
		$hit_particles.emitting = true
		$particle_timer.start()

func _on_particle_timer_timeout():
	$hit_particles.emitting = false
