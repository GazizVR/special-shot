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
	var host: String = $JoinMenu/HostEdit.text
	if host.is_empty():
		$JoinMenu/ErrLabel.text = "Error: Invalid host"
		return
		
	var port: int
	var port_str: String = $JoinMenu/PortEdit.text
	if !port_str.is_valid_int():
		$JoinMenu/ErrLabel.text = "Error: Invalid port"
		return
	port = port_str.to_int()
	
	var error: Error = Error.OK
	error = NetworkHandler.init_client(host,port)
	if error != Error.OK:
		$JoinMenu/ErrLabel.text = "Error: code " + str(error)
		return
	
func _on_start_btn_pressed() -> void:
	var port: int
	var port_str: String = $HostMenu/PortEdit.text
	if !port_str.is_valid_int():
		$HostMenu/ErrLabel.text = "Error: Invalid port"
		return
	port = port_str.to_int()
	
	var error: Error = Error.OK
	error = NetworkHandler.init_server(port)
	if error != Error.OK:
		$HostMenu/ErrLabel.text = "Error: code " + str(error)
		return
	error = get_tree().change_scene_to_file("res://scenes/Game.tscn")	
	if error != Error.OK:
		$HostMenu/ErrLabel.text = "Error: code " + str(error)
		return
	
func _on_host_back_btn_pressed() -> void:
	$HostMenu.visible = false
	$MainMenu.visible = true
	
func _ready() -> void:
	multiplayer.connected_to_server.connect(connected)
	multiplayer.connection_failed.connect(connection_failed)
	
func connected() -> void:
	var error: Error = Error.OK
	error = get_tree().change_scene_to_file("res://scenes/Game.tscn")	
	if error != Error.OK:
		$JoinMenu/ErrLabel.text = "Error: code " + str(error)
		return

func connection_failed() -> void:
	$JoinMenu/ErrLabel.text = "Error: Connection failed"
