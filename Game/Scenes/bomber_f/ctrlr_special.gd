extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_special']
		coltdown_time = 8
		await super._ready()

func active():
	await super.active()
	$special.active()
