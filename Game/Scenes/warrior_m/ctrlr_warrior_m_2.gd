extends IControllerSpell

func _ready():
	key = KEY_Z
	coltdown_time = 6
	await super._ready()

func active():
	coltdown.start()
	$spell_warrior_m_2.active()

