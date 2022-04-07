extends Area2D
#this script is used by the enemy attack
#Author : Henri 'Biscuit Prime' Nomico

func _on_EnemyAttack_body_entered(body):
	if(body.is_in_group("Player")):
		body.queue_free()
	pass # Replace with function body.

