extends Control

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_host_btn_pressed() -> void:
	$MainMenu.visible = false
	$HostMenu.visible = true

func _on_join_btn_pressed() -> void:
	$MainMenu.visible = false
	$JoinMenu.visible = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and $JoinMenu.visible:
		$JoinMenu.visible = false
		$MainMenu.visible = true
		
func _on_join_back_btn_pressed() -> void:
	$JoinMenu.visible = false
	$MainMenu.visible = true

func _on_connect_btn_pressed() -> void:
	var host: String
	var port: int
	
	host = $JoinMenu/HostEdit.text
	port = int($JoinMenu/PortEdit.text)
	
	NetworkHandler.init_client(host,port)
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_start_btn_pressed() -> void:
	var port: int
	port = int($HostMenu/PortEdit.text)
	NetworkHandler.init_server(port)
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_host_back_btn_pressed() -> void:
	$HostMenu.visible = false
	$MainMenu.visible = true
