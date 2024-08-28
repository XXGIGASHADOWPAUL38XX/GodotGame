extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = KEY_D
		coltdown_time = 8
		await super._ready()

func active():
	super.active()
	$special.can_active()
