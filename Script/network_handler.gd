extends Node

const IP_ADDRESS: String = "localhost"
const PORT: int = 6769

var peer : ENetMultiplayerPeer

func start_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, 6)
	multiplayer.multiplayer_peer = peer

func start_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
