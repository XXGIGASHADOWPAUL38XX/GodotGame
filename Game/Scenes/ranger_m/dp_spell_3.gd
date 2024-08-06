extends IDuplication

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_" + ennemies_of_current()[id - 1].name

# Called when the node enters the scene tree for the first time.
func _ready():
	# VALUES TO OVERRIDE #
	dp_number = ennemies_of_current().size()
	
	dp_callable_name = name_callable
	dp_node = $spell_3
	
	await super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ennemies_of_current():
	return ServiceScenes.ennemiesNode if is_multiplayer_authority() else ServiceScenes.alliesNode
