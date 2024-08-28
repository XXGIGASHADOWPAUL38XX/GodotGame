extends IControllerKeyPressed

func after_ready():
	if is_multiplayer_authority():
		key = KEY_R
		coltdown_time = 12
		await super.after_ready()

func active():
	super.active()
	$shield_crystal.can_active()

