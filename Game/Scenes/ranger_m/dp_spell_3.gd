extends IDuplication

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_" + ennemies_of_current()[id - 1].name

# Called when the node enters the scene tree for the first time.
func after_ready():
	# VALUES TO OVERRIDE #
	dp_number = ennemies_of_current().size()
	
	dp_callable_name = name_callable
	dp_node = $spell_3
	
	await super.after_ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ennemies_of_current():
	var champion = ServiceScenes.get_player_from_property('id', get_multiplayer_authority()).node
	return ServiceScenes.ennemiesNode if ServiceScenes.is_on_same_team(champion, ServiceScenes.championNode) else ServiceScenes.alliesNode
