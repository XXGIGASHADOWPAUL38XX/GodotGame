extends IDuplication

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_R" + str(id)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# VALUES TO OVERRIDE #
	dp_number = 15
	dp_callable_name = name_callable
	dp_node = $spell
	await super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

