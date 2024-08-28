extends IDuplication

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_" + ennemies_sorted()[id - 1].name

# Called when the node enters the scene tree for the first time.
func after_ready():
	# VALUES TO OVERRIDE #
	dp_number = ennemies_sorted().size()
	
	dp_callable_name = name_callable
	dp_node = $red_orb_passive
	
	await super.after_ready()

func ennemies_sorted():
	var champion = ServiceScenes.get_player_from_property('id', get_multiplayer_authority()).node
	var ennemies = ServiceScenes.ennemiesNode if ServiceScenes.is_on_same_team(champion, ServiceScenes.championNode) else ServiceScenes.alliesNode
	ennemies.sort()
	return ennemies
