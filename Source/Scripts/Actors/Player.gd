extends Actors
#This script is used by the Player scene
#Author : Henri 'Biscuit Prime' Nomico

# Variables :
onready var anim = $AnimatedSprite
var health
var facing := false
#NOTE IMPORTANTE : MACHINE A ETAT PLUTOT ICI, MAIS J'AVAIS PAS LE TEMPS 
var is_attacking
var is_rolling
var is_dying
var is_hit
var can_roll
var can_attack

export (PackedScene) var attack
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	health=10
	anim.animation="idle"
	anim.play()
	anim.flip_h=facing
	is_attacking=false
	is_rolling=false
	is_dying=false
	is_hit=false
	can_attack=true
	can_roll=true
	rng.randomize()
	add_to_group("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	skills() #calls the skills test function
	pass

func _physics_process(delta):
	_direction = getDirection()
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	_velocity = calculateVelocity(_velocity, _direction, is_jump_interrupted)
	if(!is_attacking):
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL) #FLOOR_NORMAL est nécessaire pour que "is_on_floor()" fonctionne
		animation(_direction)
	pass

#Function that calculates the velocity
func calculateVelocity(
		velocity : Vector2,
		direction : Vector2,
		is_jump_interrupted : bool
):
	var velocity_out: = velocity
	velocity_out.x = speed.x * direction.x
	velocity_out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		anim.animation="jump"
		anim.play()
		velocity_out.y = speed.y * direction.y
	if is_jump_interrupted :
		velocity_out.y = 0
	return velocity_out

#Function that calculates the player's direction
func getDirection():
	return Vector2(Input.get_action_strength("right")-Input.get_action_strength("left"),
	-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0)

#function that handles the animations of the player
func animation(direction):
	if(!is_attacking && !is_rolling && !is_hit && !is_dying):
		if(direction.x>0): 
			facing = false
		elif(direction.x<0) : 
			facing=true
		anim.flip_h=facing
		if(_velocity.x!=0):
			anim.animation="walk"
			anim.play()
		if(_velocity==Vector2.ZERO):
			anim.animation="idle"
			anim.play()
	pass

#function that handles the player's skills
func skills():
	if(Input.is_action_just_pressed("attack") && is_on_floor() && !is_rolling && !is_hit && !is_dying && can_attack):
		attack()
	if(Input.is_action_just_pressed("roll") && is_on_floor() && !is_attacking && !is_hit && !is_dying && can_roll):
		roll()
	pass

#function that handles the player's basic attack
func attack():
	can_attack=false
	var new_attack = attack.instance() #new attack instance
	is_attacking=true
	var my_random_number = rng.randi_range(0, 1)
	attackAnimation(my_random_number)
	if(facing):
		new_attack.position=get_global_position() + Vector2(-50,-10)
	else:
		new_attack.position=get_global_position() + Vector2(50,-10)
	get_parent().add_child(new_attack)
	yield(anim,"animation_finished")
	new_attack.queue_free()
	is_attacking=false
	$AttackTimer.start() #we start the timer that will allow us to attack again
	pass

#function that handles the attack animation
func attackAnimation(random:int):
	if(random==0):
		anim.animation="main_attack_1"
		anim.play()
	else:
		anim.animation="main_attack_2"
		anim.play()
	pass

#function that handles the player's roll
func roll():
	can_roll=false
	is_rolling=true
	anim.animation="roll"
	anim.play()
	yield(anim,"animation_finished")
	is_rolling=false
	$RollTimer.start()
	pass

#function that handles the player being hit
func hit():
	is_hit=true
	health-=1
	if(health==0):
		death()
	anim.animation="hit"
	anim.play()
	yield(anim,"animation_finished")
	is_hit=false
	pass

func death():
	is_dying=true
	anim.animation="death"
	anim.play()
	yield(anim,"animation_finished")
	queue_free()
	pass

#end of attack timer
func _on_AttackTimer_timeout():
	can_attack=true
	pass # Replace with function body.

#end of roll timer
func _on_RollTimer_timeout():
	can_roll=true
	pass # Replace with function body.
