extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = KEY_R
		coltdown_time = 12
		await super._ready()

func active():
	super.active()
	$shield_crystal.can_active()

