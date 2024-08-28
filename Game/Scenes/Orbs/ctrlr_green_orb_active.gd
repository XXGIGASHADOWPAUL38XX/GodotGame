extends IControllerKeyPressed

func after_ready():
	if is_multiplayer_authority():
		key = KEY_F
		coltdown_time = 12
		await super.after_ready()

func active():
	super.active()
	$green_orb_active.can_active()
	
