extends IControllerKeyPressed

func _ready():
	key = KEY_E
	coltdown_time = 4
	
	await super._ready()
			
func active():
	super.active()
	$spell_mage_f_3/spell_mage_f_3_HBOX.can_active()
