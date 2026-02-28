extends State
class_name EnemyIdle

@export var enemy: CharacterBody3D
@export var move_speed := 3.0

var player: CharacterBody3D
var move_direction : Vector3
var wander_time : float


func randomize_wander():
	move_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 2)
	
func enter():
	player = get_tree().get_first_node_in_group("player")
	randomize_wander()
	
func update(_delta: float):
	if wander_time > 0:
		wander_time -= _delta
		
	else:
		randomize_wander()
		
func physics_update(_delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
		enemy.move_and_slide()
	
	var direction = enemy.global_position - player.global_position 
	
	if direction.length() < 10:
		print("player detected, initiate chase")
		Transitioned.emit(self, "chase")
