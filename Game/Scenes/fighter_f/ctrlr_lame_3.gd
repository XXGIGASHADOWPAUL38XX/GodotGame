extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = KEY_E
		coltdown_time = 6
		await super._ready()

func active():
	pass
