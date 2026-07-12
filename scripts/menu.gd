extends Control

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_host_btn_pressed() -> void:
	$MainMenu.visible = false
	$HostMenu.visible = true

func _on_join_btn_pressed() -> void:
	$MainMenu.visible = false
	$JoinMenu.visible = true
	
func _on_join_back_btn_pressed() -> void:
	$JoinMenu.visible = false
	$MainMenu.visible = true

var host: String
var port: int

func _on_next_btn_pressed() -> void:
	host = $JoinMenu/HostEdit.text
	if host.is_empty():
		$JoinMenu/ErrLabel.text = "Error: Invalid host"
		return
		
	var port_str: String = $JoinMenu/PortEdit.text
	if !port_str.is_valid_int():
		$JoinMenu/ErrLabel.text = "Error: Invalid port"
		return
	port = port_str.to_int()
	cnn_type = ConnectionType.Join
	$JoinMenu.visible = false
	$TeamMenu.visible = true

enum ConnectionType{Host,Join}
var cnn_type: ConnectionType
	
func _on_start_btn_pressed() -> void:
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
		
	cnn_type = ConnectionType.Host
	$HostMenu.visible = false
	$TeamMenu.visible = true
	
func _on_host_back_btn_pressed() -> void:
	$HostMenu.visible = false
	$MainMenu.visible = true
	
func _ready() -> void:
	multiplayer.connected_to_server.connect(connected)
	multiplayer.connection_failed.connect(connection_failed)
	
func connected() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

var has_timer = false

func connection_failed() -> void:
	$JoinMenu/ErrLabel.text = "Error: Connection failed"
	$TeamMenu.visible = false
	has_timer = false
	$JoinMenu.visible = true

func _on_team_back_btn_pressed() -> void:
	multiplayer.multiplayer_peer.close()
	$TeamMenu.visible = false
	has_timer = false
	match cnn_type:
		ConnectionType.Host:
			$HostMenu.visible = true
		ConnectionType.Join:
			$JoinMenu.visible = true
		_:
			$MainMenu.visible = true

func _on_zero_team_btn_pressed() -> void:
	GameManager.selected_team = GameManager.Team.ZERO
	if cnn_type == ConnectionType.Host:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	if cnn_type == ConnectionType.Join:
		if !has_timer:
			has_timer = true
			
			var error: Error = Error.OK
			error = NetworkHandler.init_client(host,port)
			if error != Error.OK:
				$JoinMenu/ErrLabel.text = "Error: code " + str(error)
				_on_team_back_btn_pressed()
		
			await get_tree().create_timer(3).timeout
			if multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTING:
				multiplayer.multiplayer_peer.close()

func _on_unit_team_btn_pressed() -> void:
	GameManager.selected_team = GameManager.Team.UNIT
	if cnn_type == ConnectionType.Host:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	if cnn_type == ConnectionType.Join:
		if !has_timer:
			has_timer = true
			
			var error: Error = Error.OK
			error = NetworkHandler.init_client(host,port)
			if error != Error.OK:
				$JoinMenu/ErrLabel.text = "Error: code " + str(error)
				_on_team_back_btn_pressed()
		
			await get_tree().create_timer(3).timeout
			if multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTING:
				multiplayer.multiplayer_peer.close()
