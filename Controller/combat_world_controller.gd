extends Node3D


var game_done := false;

func _ready() -> void:
	AudioController.play_combat_music()
	$GameTimer.timeout.connect(end_game)
	$GameTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not game_done:
		var time_left = $GameTimer.time_left
	
	pass


func end_game():
	game_done = true
	print("FINISHED!")
	await get_tree().create_timer(1.0).timeout  # optional delay
	get_tree().change_scene_to_file("res://Scene/world.tscn");
