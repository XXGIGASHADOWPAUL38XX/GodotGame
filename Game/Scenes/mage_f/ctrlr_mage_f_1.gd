extends IControllerKeyPressed

func _ready():
	key = KEY_A
	coltdown_time = 4
	await super._ready()
			
func active():
	$spells_mage_f_1.active()
	coltdown.start()
