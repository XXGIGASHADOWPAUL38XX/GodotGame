extends IControllerKeyPressed

func after_ready():
	if is_multiplayer_authority():
		key = KEY_Z
		coltdown_time = 6
		
		await super.after_ready()

func active():
	super.active()
	$dash.can_active()
	await get_tree().create_timer(0.5).timeout
	$dash.can_active()

