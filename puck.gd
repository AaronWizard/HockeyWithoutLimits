extends KinematicBody2D

export(Vector2) var velocity

var _moving

func _ready():
	_moving = false

func _start_moving():
	_moving = true

func _physics_process(delta):
	if _moving:
		var rel_vec = velocity * delta
		var collision = move_and_collide(rel_vec)
		while collision:
			if collision.collider is preload("res://stick.gd"):
				collision.collider.do_bump()
			velocity = velocity.bounce(collision.normal)
			rel_vec = collision.remainder.bounce(collision.normal)
			collision = move_and_collide(rel_vec)