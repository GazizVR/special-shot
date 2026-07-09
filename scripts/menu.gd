extends Control


func _on_play_btn_pressed() -> void:
	NetworkHandler.init_server()
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_button_pressed() -> void:
	NetworkHandler.init_client()
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
