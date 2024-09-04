extends Node

var client = ENetMultiplayerPeer.new()
var player_db_id

const PORT = 9999
var ADDRESS = '127.0.0.1'
var data = {}

var connected_peer_ids = []

signal new_player_connected(player_id: int)
signal player_disconnected(player_id: int)

var peer_id

func createClient():
	client = ENetMultiplayerPeer.new()
	client.create_client(
			ADDRESS, 
			PORT)
	multiplayer.multiplayer_peer = client

func removeClient():
	rpc('rpc_remove_client', get_client_id())
	remove_player_character(get_client_id())

@rpc
func rpc_remove_client():
	pass

@rpc
func remove_player_client():
	remove_player_character(get_client_id())

func add_player_character(player_id):
	connected_peer_ids.append(player_id)
	new_player_connected.emit(player_id)

func remove_player_character(player_id):
	connected_peer_ids.remove_at(connected_peer_ids.find(player_id))
	player_disconnected.emit(player_id)

@rpc
func add_newly_connected_player(new_peer_id):
	add_player_character(new_peer_id)
	peer_id = new_peer_id

@rpc
func prev_players(players_id):
	for player_id in players_id:
		add_player_character(player_id)

func get_connected_clients():
	return connected_peer_ids

func get_client_id():
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
