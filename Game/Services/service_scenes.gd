extends Node
var end_screen = preload("res://Game/Scenes/End_Screen/end_screen.tscn").instantiate()

# OBJECTS PLAYERS
var players
var champion

# NODES PLAYERS
var championNode
var allyNode

#CATEGORIES NODES PLAYERS
var alliesNode = []
var ennemiesNode = []
var allPlayersNode = []
var allEnnemiesNode = [] # INCLUDE MONSTERS AND OBJECTS

# REFERENCES TO SCENES
var root_scene
var loading_game
var main_scene
var HUD
var items
var camera
var SENode
var rochers

# SPECIALS
var entites = []

# SPECIALS
var CONFIG_NB_PLAYERS_GAME = null

func set_player_node(player, node_player):
	players[players.find(player)].node = node_player

func set_players(set_players):
	players = set_players

func get_players():
	return players
	
func set_global_players():
	champion = players.filter(
		func(obj):
			return obj.id == Server.get_actual_player()
	)[0]
	championNode = champion.node
	
	alliesNode += players.filter(func(obj): return obj.is_ally()).map(
		func(obj): return obj.node
	)
		
	ennemiesNode = players.filter(func(obj): return !obj.is_ally()).map(
		func(obj): return obj.node
	)
		
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
	##!!
	node.add_child(end_screen)
	node.get_parent().get_parent().get_node(Server.get_opponent()).add_child(end_screen)
	
	node.get_node('end_screen').end_game(false)
	node.get_parent().get_parent().get_node(Server.get_opponent()).end_game(true)
	
func is_on_same_team(champion_1, champion_2):
	var team_champion_1 = alliesNode if champion_1 in alliesNode else ennemiesNode
	return champion_2 in team_champion_1
	
func add_as_ennemy(ennemy: Node2D):
	allEnnemiesNode.append(ennemy)
