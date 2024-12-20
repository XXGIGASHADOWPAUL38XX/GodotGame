extends IControllerKeyPressed

func _ready():
	key = ServiceSettings.keys_values['key_spell_3']
	coltdown_time = 4
	
	await super._ready()
			
func active():
	await super.active()
	$spell_mage_f_3/spell_mage_f_3_HBOX.active()
	spells_placeholder.ctrl_s_1.coltdown.stop()
