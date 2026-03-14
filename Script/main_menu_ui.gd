extends Control

const WORLD = "res://Scene/world.tscn"

func _on_server_pressed() -> void:
	NetworkHandler.start_server();
	get_tree().change_scene_to_file(WORLD)


func _on_client_pressed() -> void:
	NetworkHandler.start_client()
	get_tree().change_scene_to_file(WORLD)
