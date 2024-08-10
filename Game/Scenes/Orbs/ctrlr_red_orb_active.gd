extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = KEY_F
		coltdown_time = 12
		await super._ready()

func active():
	$red_orb_active.active()
