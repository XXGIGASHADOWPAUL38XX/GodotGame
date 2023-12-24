extends Node

var client = ENetMultiplayerPeer.new()

const PORT = 9999
var ADDRESS = '86.202.179.214'
var data = {}

var connected_peer_ids = []
var peer_id

func createClient():
	client.create_client(
		ADDRESS, 
		PORT)
	multiplayer.multiplayer_peer = client

func add_player_character(player_id):
	connected_peer_ids.append(player_id)

@rpc
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)
	peer_id = new_peer_id

@rpc
func prev_players(players_id):
	for player_id in players_id:
		add_player_character(player_id)

func get_connected_clients():
	return connected_peer_ids

func get_actual_player():
	return client.get_unique_id()

func get_opponent():
	return connected_peer_ids.filter(func(obj):
		return obj != client.get_unique_id())[0]

func get_first_player_connected_id():
	return connected_peer_ids[0]

func send_data(key, value):
	rpc("send_data_to_server", [key, value])

@rpc("any_peer")
func send_data_to_server(_dictionnairy):
	pass

@rpc
func send_data_to_client(_dictionnairy):
	data = _dictionnairy

func get_data(value):
	if (data.get(value) != null):
		return data[value]
