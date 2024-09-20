extends Node2D

var player_scene
var class_hero = preload("res://Game/Classes/Hero/Hero.gd").new()
var service_time = preload("res://Game/Services/service_time.gd").new()

const MENU_SCENE_PATH = "res://Game/Scenes/Menu/menu_scene.tscn"

var ennemy_spells = []

var	node_heros

var list_effects
var shared_effects

var round = 1
signal wait_sync_complete(result)

func _ready():
	ResourceLoader.load_threaded_request(MENU_SCENE_PATH)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	ServiceScenes.main_scene = self
	
	var champions = ServiceScenes.get_players()
	var champions_node_scenes = []
		
	for i in range(champions.size()):
		var champion = champions[i]
		player_scene = ResourceLoader.load_threaded_get(champion.nodePath).instantiate()
		player_scene.set_multiplayer_authority(champion.id)
		node_heros = player_scene.get_node(champion.name as NodePath)
		
		ServiceScenes.set_player_node(champion, node_heros)
		champions_node_scenes.append(player_scene)
	
	ServiceScenes.set_global_players()
		
	 # --------------------------------- AJOUT DES SCENES ---------------------------------------

	var teleporters = preload("res://Game/Scenes/Teleportation/teleportation.tscn").instantiate()
	teleporters.set_multiplayer_authority(Server.get_first_player_connected_id())
	self.add_child(teleporters)
	
	for champions_scenes in champions_node_scenes:
		self.add_child(champions_scenes)

	var items_scene = preload("res://Game/Scenes/Items/items.tscn").instantiate()
	self.add_child(items_scene)
	
	var events_scene = preload("res://Game/Scenes/Events/events.tscn").instantiate()
	events_scene.set_multiplayer_authority(Server.get_first_player_connected_id())
	self.add_child(events_scene)

	var stats_scene = preload("res://Game/Scenes/Stats_Heros/stats_heros.tscn").instantiate()
	self.add_child(stats_scene)
	
	var mini_map = preload("res://Game/Scenes/MiniMap/mini_map.tscn").instantiate()
	self.add_child(mini_map)
	
	var shared_effects = preload("res://Game/Scenes/Shared_Effects/shared_effects.tscn").instantiate()
	shared_effects.set_multiplayer_authority(Server.get_first_player_connected_id())
	self.add_child(shared_effects)
	
	var end_screen = preload("res://Game/Scenes/End_Screen/end_screen.tscn").instantiate()
	self.add_child(end_screen)
	
	if ServiceScenes.champion.id == Server.get_first_player_connected_id():
		ServiceRounds.init_first_round()
	
	# ------------------------------------------------------------------------------------- #

func return_to_menu():
	var menu_scene = ResourceLoader.load_threaded_get(MENU_SCENE_PATH).instantiate()
	ServiceScenes.root_scene.add_child(menu_scene)
	self.queue_free()

func _process(delta):
	pass

