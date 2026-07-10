extends Node

var peer: ENetMultiplayerPeer

func init_server(port: int) -> void: 
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer

func init_client(host: String,port: int) -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(host,port)
	multiplayer.multiplayer_peer = peer
