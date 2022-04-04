extends KinematicBody2D
#This script is used by the enemies
#Author : Henri 'Biscuit Prime' Nomico

onready var anim = $AnimatedSprite

func _ready():
	anim.animation="idle"
	anim.play()
	add_to_group("Enemy")

func hit():
	anim.animation="hit"
	anim.play()
	yield(anim,"animation_finished")
	queue_free()
