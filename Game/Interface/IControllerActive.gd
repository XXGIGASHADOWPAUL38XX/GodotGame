extends Node2D

class_name IControllerActive

var cond_spells: Array[Callable]

var spells_placeholder: IPlaceholderSpells

# Called when the node enters the scene tree for the first time.
func _ready():
	after_ready()

func after_ready():
	if is_multiplayer_authority():
		spells_placeholder_f()
		
		await await_resource_loaded(func(): return self.spells_placeholder != null)
		await await_resource_loaded(func(): return spells_placeholder.spells_dependencies_ready)

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
	
func await_resource_loaded(c: Callable, retry_timeout: float=0.05):
	while c.get_object() != null && !c.call():
		await c.get_object().get_tree().create_timer(retry_timeout).timeout

