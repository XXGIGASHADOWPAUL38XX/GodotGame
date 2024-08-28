extends IDuplication

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_R" + str(id)
	
func after_ready():
	# VALUES TO OVERRIDE #
	dp_number = 9
	dp_callable_name = name_callable
	dp_node = $special_ranger_m
	await super.after_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
