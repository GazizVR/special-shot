extends Node

var peer: ENetMultiplayerPeer

func init_server(port: int) -> Error:
	var error: Error = Error.OK
	peer = ENetMultiplayerPeer.new()
	error = peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	return error

func init_client(host: String,port: int) -> Error:
	var error: Error = Error.OK
	peer = ENetMultiplayerPeer.new()
	error = peer.create_client(host,port)
	multiplayer.multiplayer_peer = peer
	return error
