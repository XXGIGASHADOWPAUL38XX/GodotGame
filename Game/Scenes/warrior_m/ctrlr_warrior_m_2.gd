extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = KEY_Z
		coltdown_time = 6
			
		await super._ready()

func active():
	super.active()
	$spell_warrior_m_2.can_active()

