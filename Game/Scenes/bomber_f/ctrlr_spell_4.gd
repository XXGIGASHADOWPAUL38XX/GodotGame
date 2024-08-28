extends IControllerKeyPressed

var shoots

func after_ready():
	if is_multiplayer_authority():
		key = KEY_SPACE
		coltdown_time = 12
		await super.after_ready()
		
		shoots = $dp_spell_4.get_children().filter(func(s): return s is IActive)

func active():
	super.active()
	shoots.map(func(s): s.can_active())
