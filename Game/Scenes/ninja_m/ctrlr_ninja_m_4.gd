extends IControllerKeyPressed

var spell_nodes

func after_ready():
	if is_multiplayer_authority():
		key = KEY_SPACE
		coltdown_time = 2
		await super.after_ready()
		
		spell_nodes = $dp_ninja_m_4.get_children().filter(func(c): return c.name.begins_with('spell'))

func active():
	super.active()
	spell_nodes.map(func(spell_node): spell_node.can_active())
	

