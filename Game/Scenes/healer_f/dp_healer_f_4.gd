extends IDuplication

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_" + champions_sorted()[id - 1].name

# Called when the node enters the scene tree for the first time.
func _ready():
	# VALUES TO OVERRIDE #
	dp_number = champions_sorted().size()
	
	dp_callable_name = name_callable
	dp_node = $heal_f_4
	
	await super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func champions_sorted():
	var entities = ServiceScenes.ennemiesNode + ServiceScenes.alliesNode
	entities.sort()
	return entities
