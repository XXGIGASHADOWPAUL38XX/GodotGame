extends IDuplication

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_" + allies_sorted()[id - 1].name

# Called when the node enters the scene tree for the first time.
func _ready():
	# VALUES TO OVERRIDE #
	dp_number = allies_sorted().size()
	
	dp_callable_name = name_callable
	dp_node = $special_healer_f
	
	await super._ready()


func allies_sorted():
	var champion = ServiceScenes.get_player_from_property('id', get_multiplayer_authority()).node
	var allies = ServiceScenes.alliesNode if ServiceScenes.is_on_same_team(champion, ServiceScenes.championNode) else ServiceScenes.ennemiesNode
	allies.sort()
	return allies
