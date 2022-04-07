extends Area2D
#This script is used by the player attack
#author : Henri 'Biscuit Prime' Nomico

func _on_Attack_body_entered(body):
	if(body.is_in_group("Enemy")):
		body.hit()
	pass # Replace with function body.
