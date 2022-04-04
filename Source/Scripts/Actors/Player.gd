extends Actors
#This script is used by the Player scene
#Author : Henri 'Biscuit Prime' Nomico

# Variables :
onready var anim = $AnimatedSprite
var facing :=false
var is_attacking

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.animation="idle"
	anim.play()
	anim.flip_h=facing
	is_attacking=false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	skills() #calls the skills test function
	_direction = getDirection()
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	_velocity = calculateVelocity(_velocity, _direction, is_jump_interrupted)
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
	if(!is_attacking):
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

func skills():
	if(Input.is_action_just_pressed("attack") && is_on_floor()):
		attack()
	pass

func attack():
	is_attacking=true
	anim.animation="attack"
	anim.play()
	yield(anim,"animation_finished")
	is_attacking=false
	pass
