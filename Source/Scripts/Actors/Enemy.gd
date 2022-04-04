extends Actors
#This script is used by the enemies
#Author : Henri 'Biscuit Prime' Nomico

onready var anim = $AnimatedSprite
export var health : int

func _ready():
	anim.animation="idle"
	anim.play()
	add_to_group("Enemy")

func hit():
	anim.animation="hit"
	anim.play()
	yield(anim,"animation_finished")
	anim.animation="idle"
	anim.play()
	health-=1
	if(health<=0):
		queue_free()

func _process(delta):
	_velocity.y += gravity * get_physics_process_delta_time()
	_velocity = move_and_slide(_velocity,FLOOR_NORMAL)
	pass
