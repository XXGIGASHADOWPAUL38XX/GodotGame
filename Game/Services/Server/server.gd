extends Node

var resource_awaiter = ResourceAwaiter.new()
var client = ENetMultiplayerPeer.new()
var player_controller = PlayerController.new()
var gdict = Gdict.new()

var current_dbplayer
var current_playerpeer

const PORT = 9999
var ADDRESS = '127.0.0.1'
var data = {}

var connected_peer_ids = []
var connected_ppeers: Array = []

signal user_set

signal new_player_connected(player_id: int)
signal player_disconnected(player_id: int)
signal players_updated(players: Array[PlayerPeer])

var peer_id

func createClient():
	client = ENetMultiplayerPeer.new()
	client.create_client(
			ADDRESS, 
			PORT)
	multiplayer.multiplayer_peer = client
	
	await resource_awaiter.await_resource_loaded(func(): 
		return 1 in multiplayer.get_peers()
	)

	await player_controller.set_session_id(get_client_id())
	Servrpc.any(self, 'send_signal_user_set', [])

func send_signal_user_set():
	user_set.emit()

func removeClient():
	rpc('rpc_remove_client', get_client_id())
	remove_player_character(get_client_id())

@rpc
func rpc_remove_client():
	pass

func add_player_character(player_id):
	connected_peer_ids.append(player_id)
	connected_ppeers.append(PlayerPeer.new(player_id))
	
	await user_set
	new_player_connected.emit(player_id)

func remove_player_character(player_id):
	connected_peer_ids.remove_at(connected_peer_ids.find(player_id))
	connected_ppeers.filter(func(cp): return cp.id != player_id)
	
	player_disconnected.emit(player_id)

## QUAND UN NOUVEAU PEER SE CONNECTE DU COTE DES AUTRES PEERS
@rpc
func add_newly_connected_player(new_peer_id):
	add_player_character(new_peer_id)
	peer_id = new_peer_id

## QUAND UN NOUVEAU PEER SE CONNECTE DU COTE DU NOUVEAU PEER
@rpc
func prev_players(players_id):
	for player_id in players_id:
		add_player_character(player_id)

@rpc
func remove_player_client(peer_id):
	remove_player_character(peer_id)
	
func get_connected_clients():
	return connected_peer_ids

func get_client_id():
	return client.get_unique_id()

func get_opponent():
	return connected_peer_ids.filter(func(obj):
		return obj != client.get_unique_id())[0]

func get_first_player_connected_id():
	return connected_peer_ids[0]
	
func update_playerpeer_id(id, attribute, value):
	await resource_awaiter.await_resource_loaded(func(): 
		return connected_ppeers.filter(func(cp): return cp.id == id).size() != 0
	)
	
	connected_ppeers.filter(func(cp): return cp.id == id)[0].set(attribute, value)
	players_updated.emit(connected_ppeers)
	
func get_ppeer_from_id(peer_id):
	return connected_ppeers.filter(func(cp): return cp.id == peer_id)[0]

func get_ppeer_id_from_name(username):
	return connected_ppeers.filter(func(cp): return cp.username == username)[0].id

func retreive_session(client_id):
	rpc("server_retreive_session", client_id)
	
@rpc
func server_retreive_session(client_id):
	pass
