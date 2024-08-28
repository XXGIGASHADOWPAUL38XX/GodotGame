extends IDuplication

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_R" + str(id)
	
const ORB_WITH_AUTH: int = 1
var current_orb: int = 1

# Called when the node enters the scene tree for the first time.
func after_ready():
	# VALUES TO OVERRIDE #
	dp_number = 4
	dp_callable_name = name_callable
	dp_node = $s_orbs_mage_f_2
	await super.after_ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func increment_current_orb():
	current_orb = (current_orb % 4) + 1
