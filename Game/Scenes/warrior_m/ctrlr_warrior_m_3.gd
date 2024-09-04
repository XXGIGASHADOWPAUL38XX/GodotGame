extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_3']
		coltdown_time = 8
		await super._ready()

func active():
	await super.active()
	$spell_warrior_m_3.active()

	
