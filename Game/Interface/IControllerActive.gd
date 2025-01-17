extends Node2D

class_name IControllerActive

var cond_spells: Array[Callable]

var spells_placeholder: IPlaceholderSpells

var resource_awaiter = ResourceAwaiter.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		spells_placeholder_f()
		
		await resource_awaiter.await_resource_loaded(func(): return self.spells_placeholder != null)
		await resource_awaiter.await_resource_loaded(func(): return spells_placeholder.spells_dependencies_ready)

func spells_placeholder_f(node: Node = self):
	if node is IPlaceholderSpells:
		spells_placeholder = node
		return null
	if node.get_parent() != null && node.get_parent() != ServiceScenes.main_scene:
		return spells_placeholder_f(node.get_parent())
		
	return null

func active():
	pass
	
func can_active():
	if is_multiplayer_authority() && cond_spells.all(func(c: Callable): return c.call()):
		active()
