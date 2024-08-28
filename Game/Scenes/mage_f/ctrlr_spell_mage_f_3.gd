extends IControllerKeyPressed

func after_ready():
	key = KEY_E
	coltdown_time = 4
	
	await super.after_ready()
			
func active():
	super.active()
	$spell_mage_f_3/spell_mage_f_3_HBOX.can_active()
