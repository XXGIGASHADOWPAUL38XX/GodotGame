extends IControllerKeyPressed

func after_ready():
	if is_multiplayer_authority():
		key = KEY_Z
		coltdown_time = 6
		
		await super.after_ready()

func active():
	super.active()
	$zone.can_active()
