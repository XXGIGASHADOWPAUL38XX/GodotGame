extends IControllerKeyPressed

func after_ready():
	if is_multiplayer_authority():
		key = KEY_E
		coltdown_time = 8
		await super.after_ready()

func active():
	super.active()
	$spell_warrior_m_3.can_active()

	
