extends IDuplication

var marked_entities

# Called when the node enters the scene tree for the first time.
func _ready():
	marked_entities = await ennemies_of_current()
	dp_callable_name = func dp_callable_name(id): return dp_node.name + "_" + marked_entities[id - 1].name
	
	# VALUES TO OVERRIDE #
	dp_number = marked_entities.size()
	dp_node = $mark
	
	await super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ennemies_of_current():
	await get_tree().create_timer(0.3).timeout ##!!
	
	var champion = ServiceScenes.get_player_from_property('id', get_multiplayer_authority()).node
	if ServiceScenes.is_on_same_team(champion, ServiceScenes.championNode):
		return ServiceScenes.entities.ennemiesNode + ServiceScenes.entities.entitiesNode
	else:
		return ServiceScenes.entities.alliesNode + ServiceScenes.entities.entitiesNode
