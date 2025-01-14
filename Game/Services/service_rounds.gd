extends Node

var LIST_BOSSES = ['boss_golem', 'boss_crystal']
var resource_awaiter = ResourceAwaiter.new()

func init_first_round():
	add_random_boss()
	
func new_round_global(champion_killed):
	add_random_boss()
	Servrpc.any(self, "new_round_local", [champion_killed])
	
func new_round_local(champion_killed):
	var is_victory = !(champion_killed in ServiceScenes.alliesNode)
	if is_victory:
		increment_round_won()
		
	ServiceScenes.championNode.set_multiplayer_authority(Server.get_client_id() - 1)
	
	ServiceScenes.end_screen_scene.end_game(is_victory)
	
	await get_tree().create_timer(5).timeout
	
	if ServiceScenes.players.any(func(obj): return obj.team.round_won == 3):
		last_round_ended(ServiceScenes.championNode)
		return
		
	ServiceScenes.events_scene.new_round(is_victory)
		
	ServiceScenes.championNode.set_multiplayer_authority(Server.get_client_id())
	
	ServiceScenes.entites.map(func(entity):
		if entity != null && entity.is_multiplayer_authority():
			entity.new_round()
	)
	
func last_round_ended(champion): # FONCTION GLOBALE, le champion est celui qui est mort
	ServiceScenes.main_scene.return_to_menu()

func increment_round_won():
	ServiceScenes.champion.team.round_won += 1

func add_random_boss():
	var current_boss = LIST_BOSSES.pick_random()
	Servrpc.any(self, 'add_random_boss_any', [current_boss])
	
func add_random_boss_any(current_boss):
	await resource_awaiter.await_resource_loaded(func(): return ServiceScenes.main_scene != null)
	
	for boss in LIST_BOSSES:
		if ServiceScenes.main_scene.has_node(boss + "_phldr"):
			var old_boss_node = ServiceScenes.main_scene.get_node(boss + "_phldr")
			old_boss_node.queue_free()
			await old_boss_node.tree_exited
	
	var current_boss_scene = load("res://Game/Scenes/Shared_Effects/" + current_boss + ".tscn").instantiate()
	current_boss_scene.set_multiplayer_authority(Server.get_first_player_connected_id(), true)
	ServiceScenes.main_scene.add_child(current_boss_scene)
