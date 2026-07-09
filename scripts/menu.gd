extends Control

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_host_btn_pressed() -> void:
	NetworkHandler.init_server()
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_join_btn_pressed() -> void:
	$MainMenu.visible = false
	$JoinMenu.visible = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and $HostMenu.visible:
		$JoinMenu.visible = false
		$MainMenu.visible = true
		
func _on_back_btn_pressed() -> void:
	$JoinMenu.visible = false
	$MainMenu.visible = true

func _on_next_btn_pressed() -> void:
	var host: String
	host = $JoinMenu/VBoxContainer/LineEdit.text
	NetworkHandler.init_client(host)
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
