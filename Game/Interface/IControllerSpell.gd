extends Node2D

class_name IControllerSpell

var spells: Array = []
var key
var coltdown_time
var coltdown

var service_time = preload("res://Game/Services/service_time.gd").new()

var HUD
var cond_spells: Array[Callable]

var need_release: bool = false
var key_pressed: bool = false

var spells_placeholder: IPlaceholderSpells

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		spells = get_spells()
		coltdown = service_time.init_timer(self, coltdown_time)
		
		spells_placeholder_f()
		
		await await_resource_loaded(func(): return self.spells_placeholder != null)
		await await_resource_loaded(func(): return spells_placeholder.spells_dependencies_ready)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority() && cond_spells.all(func(c: Callable): return c.call()):
		if Input.is_key_pressed(key):
			if coltdown.time_left == 0 && ((need_release && !key_pressed) || !need_release):
				self.active()
				key_pressed = true
		elif need_release:
			key_pressed = false
		
func get_spells(parent=self):
	var spells = []
	for c in parent.get_children():
		if c is IDuplication:
			spells += get_spells(c)
		elif (c is IDamagingSpell && !c.is_base_dp_spell()) || (c is Area2D && !c is IDamagingSpell):
			spells.append(c)
			
	return spells

func spells_placeholder_f(node: Node = self):
	if node is IPlaceholderSpells:
		spells_placeholder = node
		return null
	if node.get_parent() != null && node.get_parent() != ServiceScenes.main_scene:
		return spells_placeholder_f(node.get_parent())
		
	return null

func active():
	pass

func await_resource_loaded(c: Callable, retry_timeout: float=0.05):
	while !c.call():
		await self.get_tree().create_timer(retry_timeout).timeout
		
	return true

