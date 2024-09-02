extends IControllerKeyPressed

func _ready():
	key = ServiceSettings.keys_values['key_spell_2']
	coltdown_time = 6
	await super._ready()

func active():
	await super.active()
	$spells_healer_f_2.active()

