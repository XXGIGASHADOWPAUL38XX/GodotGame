extends IControllerSpell

func _ready():
	key = KEY_E
	coltdown_time = 8
	await super._ready()

func active():
	$spell_warrior_m_3.active()

	coltdown.start()