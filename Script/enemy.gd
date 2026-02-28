extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var SPEED = 3.0

func _ready():
	nav_agent.target_reached.connect(_on_navigation_agent_3d_target_reached)

func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	velocity = (next_location - current_location).normalized() * SPEED
	print(nav_agent.distance_to_target())
	move_and_slide()
	
func update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_navigation_agent_3d_target_reached():
	print("in range")
	
#func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	#velocity = velocity.move_toward(safe_velocity, .25)
	#move_and_slide()
