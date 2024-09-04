extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_3']
		coltdown_time = 6
		await super._ready()

func active():
	await super.active()
	$stunning_bomb.active()
