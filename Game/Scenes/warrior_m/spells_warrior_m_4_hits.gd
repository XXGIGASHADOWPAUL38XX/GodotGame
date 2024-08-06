extends IDuplication

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_R" + str(id)

var HIT_WITH_AUTH: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# VALUES TO OVERRIDE #
	dp_number = 4
	dp_callable_name = name_callable
	dp_node = $hit_warrior_m_4
	await super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
