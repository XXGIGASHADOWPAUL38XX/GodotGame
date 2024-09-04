extends IDuplication

var keys_values
var player_controller = PlayerController.new()

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_R" + str(id)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	keys_values = ServiceSettings.keys_values
	
	# VALUES TO OVERRIDE #
	dp_number = keys_values.keys().size()
	dp_callable_name = name_callable
	dp_node = get_parent().get_node("settings_keyvalue")
	await super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
