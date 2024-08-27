extends IControllerKeyPressed

func _ready():
	key = KEY_Z
	coltdown_time = 6
	await super._ready()

func active():
	super.active()
	$spell_warrior_m_2.active()

