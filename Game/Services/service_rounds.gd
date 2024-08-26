extends Node

var LIST_BOSSES = ['boss_golem', 'boss_crystal']

func init_first_round():
	add_random_boss()
	
func new_round_global(champion_killing):
	Servrpc.send_to_id(champion_killing.get_multiplayer_authority(), self, 'new_round_global_synced', [champion_killing])
	
func new_round_global_synced(champion_killing):
	while champion_killing.get_node('health_bar').value != 0:
		await get_tree().create_timer(0.01).timeout
		
	add_random_boss()
	Servrpc.any(self, "new_round_local", [champion_killing])
	#ServiceScenes.entites.map(func(entity): entity.new_round())
	
func new_round_local(champion_killing):
	var is_victory = !(champion_killing in ServiceScenes.alliesNode)
	if is_victory:
		increment_round_won()
		
	if ServiceScenes.players.filter(func(obj): obj.team.round_won == 3).size() != 0:
		last_round_ended(ServiceScenes.championNode)
		return
	
	ServiceScenes.championNode.set_multiplayer_authority(Server.get_actual_player() - 1)
	
	get_node('end_screen').end_game(is_victory)
	self.get_node('events').new_round(is_victory)
	
	await get_tree().create_timer(5).timeout
	
	ServiceScenes.championNode.set_multiplayer_authority(Server.get_actual_player())
	
func last_round_ended(champion): # FONCTION GLOBALE, le champion est celui qui est mort
	pass

func increment_round_won():
	ServiceScenes.champion.team.round_won += 1

func add_random_boss():
	var current_boss = LIST_BOSSES.pick_random()
	Servrpc.any(self, 'add_random_boss_any', [current_boss])
	
func add_random_boss_any(current_boss):
	var current_boss_scene = load("res://Game/Scenes/Shared_Effects/" + current_boss + ".tscn").instantiate()
	current_boss_scene.set_multiplayer_authority(Server.get_first_player_connected_id())
	ServiceScenes.main_scene.add_child(current_boss_scene)
