extends Node

@export var mute: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		
func play_world_music():
	$BGMRunner.stop()
	$BGMCombat.stop()
	$BGMWorld.play()
	
func play_runner_music():
	$BGMWorld.stop()
	$BGMCombat.stop()
	$BGMRunner.play()

func play_combat_music():
	$BGMWorld.stop()
	$BGMRunner.stop()
	$BGMCombat.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
