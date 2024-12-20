extends IDuplication

var marked_entities
var name_callable: Callable

# Called when the node enters the scene tree for the first time.
func _ready():
	marked_entities = ennemies_of_current()
	name_callable = func dp_callable_name(id): return dp_node.name + "_" + marked_entities[id - 1].name
	
	# VALUES TO OVERRIDE #
	dp_number = ennemies_of_current().size()
	
	dp_callable_name = name_callable
	dp_node = $spell_3
	
	await super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ennemies_of_current():
	var champion = ServiceScenes.get_player_from_property('id', get_multiplayer_authority()).node
	return ServiceScenes.entities.ennemiesNode if ServiceScenes.is_on_same_team(champion, ServiceScenes.championNode) else ServiceScenes.entities.alliesNode
