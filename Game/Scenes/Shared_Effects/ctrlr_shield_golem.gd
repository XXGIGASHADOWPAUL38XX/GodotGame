extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_active_boss']
		coltdown_time = 12
		await super._ready()

func active():
	await super.active()
	$shield_golem.active()
