extends IControllerKeyPressed

var spell_nodes

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_ultimate']
		coltdown_time = 2
		await super._ready()
		
		spell_nodes = $dp_ninja_m_4.get_children().filter(func(c): return c.name.begins_with('spell'))

func active():
	await super.active()
	spell_nodes.map(func(spell_node): spell_node.active())
	

