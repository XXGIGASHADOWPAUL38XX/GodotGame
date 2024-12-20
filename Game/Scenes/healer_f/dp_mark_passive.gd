extends IDuplication

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_" + ennemies_sorted()[id - 1].name

# Called when the node enters the scene tree for the first time.
func _ready():
	# VALUES TO OVERRIDE #
	dp_number = ennemies_sorted().size()
	
	dp_callable_name = name_callable
	dp_node = $mark_passive
	
	await super._ready()

func ennemies_sorted():
	var champion = ServiceScenes.get_player_from_property('id', get_multiplayer_authority()).node
	var ennemies = ServiceScenes.entities.ennemiesNode if ServiceScenes.is_on_same_team(champion, ServiceScenes.championNode) else ServiceScenes.entities.alliesNode
	ennemies.sort()
	return ennemies
