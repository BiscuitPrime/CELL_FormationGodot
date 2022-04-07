extends Actors
#This script is used by the enemies
#Author : Henri 'Biscuit Prime' Nomico

onready var anim = $AnimatedSprite
onready var playerDetector = $PlayerDetector
export (PackedScene) var attack
export var health : int
var is_attacking
var is_dying
var can_attack

func _ready():
	anim.animation="idle"
	anim.play()
	add_to_group("Enemy")
	is_attacking=false
	can_attack=true
	is_dying=false

func hit():
	health-=1
	if(health<=0):
		is_dying=true
		anim.animation="death"
		anim.play()
		yield(anim,"animation_finished")
		queue_free()
	anim.animation="hit"
	anim.play()
	yield(anim,"animation_finished")
	anim.animation="idle"
	anim.play()

func _process(delta):
	_velocity.y += gravity * get_physics_process_delta_time()
	_velocity = move_and_slide(_velocity,FLOOR_NORMAL)
	if(playerDetector.is_colliding() && !is_attacking && can_attack && !is_dying): #if the enemy player is detected
		attack()
	pass

#function that handles the attack
func attack():
	can_attack=false
	var new_attack = attack.instance() #new attack instance
	is_attacking=true
	anim.animation="attack"
	anim.play()
	new_attack.position=get_global_position()+Vector2(10,0)
	yield(anim,"animation_finished")
	anim.animation="idle"
	anim.play()
	new_attack.queue_free()
	$AttackTimer.start()
	is_attacking=false
	pass

func _on_AttackTimer_timeout():
	can_attack=true
	pass # Replace with function body.
