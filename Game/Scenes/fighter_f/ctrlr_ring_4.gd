extends IControllerKeyPressed

func after_ready():
	if is_multiplayer_authority():
		key = KEY_SPACE
		coltdown_time = 8
		await super.after_ready()

func active():
	super.active()
	$change_weapon.can_active()
