extends IControllerKeyPressed

func _ready():
	key = MOUSE_BUTTON_RIGHT
	coltdown_time = 1
	await super._ready()
			
func active():
	$aa_mage_f.active()
	coltdown.start()
