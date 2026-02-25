extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
# In your World/Main scene script
func restart_game():
	# Reset player
	$Player.global_position = Vector3(0, 1, 0)
	$Player.velocity = Vector3.ZERO
	$Player.rotation.y = 0
	
	# Reset terrain controller if needed
	$TerrainController.reset_terrain()
	
	# Clear any spawned objects
	get_tree().call_group("Cleanup", "queue_free")
