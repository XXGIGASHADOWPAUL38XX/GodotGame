extends IControllerKeyPressed

func after_ready():
	if is_multiplayer_authority():
		key = KEY_D
		coltdown_time = 8
		await super.after_ready()

func active():
	super.active()
	$special.can_active()
