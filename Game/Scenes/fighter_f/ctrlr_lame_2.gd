extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_2']
		coltdown_time = 6
		
		await super._ready()

func active():
	await super.active()
	$dash.active()
	await get_tree().create_timer(0.25).timeout
	$dash.active()

