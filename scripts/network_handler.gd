extends Node

var peer: ENetMultiplayerPeer
const HOST: String = "localhost"
const PORT: int = 3333

func init_server() -> void: 
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer

func init_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(HOST,PORT)
	multiplayer.multiplayer_peer = peer
