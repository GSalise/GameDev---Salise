extends State
class_name EnemyChase

@export var enemy: CharacterBody3D
@export var move_speed := 3.0

var player: CharacterBody3D

func enter():
	player = get_tree().get_first_node_in_group("player")

func physics_update(_delta: float):
	if not player:
		return
		
	var direction = enemy.global_position - player.global_position  
	
	if direction.length() < 10: 
		print("chasing player")
		enemy.velocity = (player.global_position - enemy.global_position).normalized() * move_speed
	else:
		print("player out of range, transition to idle")
		Transitioned.emit(self, "idle")


	
	enemy.move_and_slide()
