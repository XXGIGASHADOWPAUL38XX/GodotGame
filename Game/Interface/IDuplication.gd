extends Node

class_name IDuplication

# VALUES TO OVERRIDE #
var dp_number: int
var dp_id: int = 1
var dp_callable_name: Callable
var dp_node: Node
var dp_parent
var dp_script

var is_multiple_duplication: bool = false
var is_child_mltp_duplication

var spells_placeholder
var duplication_performed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_multiple_duplication = dp_node is IDuplication
	is_child_mltp_duplication = get_parent() is IDuplication
	if is_child_mltp_duplication:
		await await_resource_loaded(func(): return get_parent().duplication_performed)
		
	dp_script = dp_node.get_script()
	dp_parent = dp_node.get_parent()
	
	spells_placeholder_f()
	
	dp_parent.child_exiting_tree.connect(func(child):
		if dp_node != null && child.name == dp_node.name:
			duplication_performed = true
			if spells_placeholder != null:
				await await_resource_loaded(func(): 
					return (child == null || !child.is_visible_in_tree()) && spells_placeholder.duplication_phldrs != null
				)
				spells_placeholder.duplication_node_performed()
	)
		
	for i in range(dp_number):
		duplicate_obj(dp_id)
		dp_id += 1

	dp_node.queue_free()
	
func duplicate_obj(id):
	var dp_object: Node = dp_node.duplicate()
	dp_object.set_multiplayer_authority(dp_node.get_multiplayer_authority())
	dp_object.set_name(dp_callable_name.call(dp_id))
	dp_object.set_script(dp_script)
	
	dp_parent.add_child(dp_object)
	
	dp_object.set_meta("dp_id", dp_id)
	
	if dp_object.has_method('post_dp_script') && is_multiplayer_authority():
		dp_object.post_dp_script(id, dp_number)
		 
		
func spells_placeholder_f(node: Node = self):
	if node is IPlaceholderSpells:
		spells_placeholder = node
		return null
	if node.get_parent() != null && node.get_parent() != ServiceScenes.main_scene:
		return spells_placeholder_f(node.get_parent())
		
	return null

func await_resource_loaded(c: Callable, retry_timeout: float=0.05):
	while c.get_object() != null && !c.call():
		await c.get_object().get_tree().create_timer(retry_timeout).timeout
