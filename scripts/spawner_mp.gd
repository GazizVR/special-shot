extends MultiplayerSpawner

@export var network_player: PackedScene

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(despawn_player)
	multiplayer.server_disconnected.connect(stop_server)
	if multiplayer.is_server():
		spawn_player(multiplayer.get_unique_id())
	
func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return
	var player = network_player.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child",player)

func stop_server() -> void:
	var root = get_node(spawn_path)
	for child in root.get_children():
		child.call_thread_safe("return_to_menu")

func despawn_player(id: int) -> void: 
	if !multiplayer.is_server(): return
	var root = get_node(spawn_path)
	for child in root.get_children():
		if child.name == str(id):
			root.call_deferred("remove_child",child)
