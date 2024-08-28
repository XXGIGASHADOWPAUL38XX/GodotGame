extends IControllerKeyPressed

func after_ready():
	if is_multiplayer_authority():
		key = KEY_E
		coltdown_time = 6
		await super.after_ready()

func active():
	super.active()
	$stunning_bomb.can_active()
