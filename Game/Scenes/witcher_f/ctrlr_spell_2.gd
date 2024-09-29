extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_2']
		coltdown_time = 6
		cast_time = 0.1
				
		await super._ready()

func active():
	await super.active()
	$zone.active()
