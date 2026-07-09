extends Node

var peer: ENetMultiplayerPeer
const PORT: int = 8080

func init_server() -> void: 
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer

func init_client(host: String) -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(host,PORT)
	multiplayer.multiplayer_peer = peer
