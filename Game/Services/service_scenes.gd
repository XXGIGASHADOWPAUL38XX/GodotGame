extends Node
var end_screen = preload("res://Game/Scenes/End_Screen/end_screen.tscn").instantiate()

# OBJECTS PLAYERS
var players
var champion
var ally
var ennemy1
var ennemy2
var player_with_obj_auth

# NODES PLAYERS
var championNode
var allyNode

#CATEGORIES NODES PLAYERS
var alliesNode = []
var ennemiesNode = []
var allPlayersNode = []
var allEnnemiesNode = [] # INCLUDE MONSTERS AND OBJECTS

var main_scene
var items
var camera
var SENode
var rochers
var ennemiesSpells: Array = []
var championSpells: Array = []

var CONFIG_NB_PLAYERS_GAME = null

func set_player_node(player, node_player):
	players[players.find(player)].node = node_player

func set_players(set_players):
	players = set_players

func get_players():
	return players
	
func set_global_players():
	for player in players:
		setSpells(player)
	
	champion = players.filter(
		func(obj):
			return obj.id == Server.get_actual_player()
	)[0]
	championNode = champion.node
	alliesNode.append(championNode)
	
	if players.size() > 2:
		ally = players.filter(
			func(obj):
				return obj.id != Server.get_actual_player() && obj.is_ally == true
		)[0]
		allyNode = ally.node
		alliesNode.append(allyNode)
		
	
	var ennemies = players.filter(
		func(obj):
			return obj.is_ally == false
	)
		
	for i in range(ennemies.size()):
		ennemiesNode.append(ennemies[i].node)
		
	player_with_obj_auth = get_player_from_property('id', Server.get_first_player_connected_id())
	allPlayersNode = alliesNode + ennemiesNode
	allEnnemiesNode += ennemiesNode

func getAllPlayersNodes():
	return allPlayersNode
	
func getPlayerByName(player_name):
	var player = players.filter(
		func(obj):
			return obj.name == player_name
	)[0]

func getMainScene():
	return main_scene
	
func setMainScene(scene):
	main_scene = scene

func getCamera():
	return camera
	
func setCamera(cam):
	camera = cam
	
func getSENode():
	return SENode
	
func setSENode(node):
	SENode = node

func getEnnemySpells():
	return ennemiesSpells

func setSpells(champion_to_set):
	for node in champion_to_set.node.get_node("spells_" + champion_to_set.name).get_children():
		if node is Area2D && node.get_name().begins_with('spell'):
			champion_to_set.spells.append(node)

func getChampionSpells():
	return championSpells

func addSpellToChampion(champion_to_add, spell, time=null):
	var player = get_player_from_property('node', champion_to_add)
	if player.spells.find(spell) == -1:
		player.spells.append(spell)
		if time != null:
			await get_tree().create_timer(time).timeout
			player.spells.pop_at(player.spells.size() - 1)

func get_player_from_property(property, value):
	return players.filter(
		func (player):
			return player.get(property) == value
	)[0]
	
func get_property_from_player(player_node, property):
	return players.filter(
		func (player):
			return player.node == player_node
	)[0].get(property)

func end_game(node):
	node.add_child(end_screen)
	node.get_parent().get_parent().get_node(Server.get_opponent()).add_child(end_screen)
	
	node.get_node('end_screen').end_game(false)
	node.get_parent().get_parent().get_node(Server.get_opponent()).end_game(true)
