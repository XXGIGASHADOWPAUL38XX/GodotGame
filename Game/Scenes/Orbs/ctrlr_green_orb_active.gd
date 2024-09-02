extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_active_item']
		coltdown_time = 12
		await super._ready()

func active():
	await super.active()
	$green_orb_active.active()
	
