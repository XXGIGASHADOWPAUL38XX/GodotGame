extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = KEY_E
		coltdown_time = 8
		await super._ready()

func active():
	super.active()
	$spell_warrior_m_3.can_active()

	
