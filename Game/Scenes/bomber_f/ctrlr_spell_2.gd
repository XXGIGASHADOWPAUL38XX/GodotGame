extends IControllerKeyPressed

var duplicated_spells

func after_ready():
	if is_multiplayer_authority():
		key = KEY_Z
		coltdown_time = 8
		
		await super.after_ready()
		duplicated_spells = $dp_spell_2.get_children()

func active():
	super.active()
	duplicated_spells.map(func(ds): ds.can_active())

