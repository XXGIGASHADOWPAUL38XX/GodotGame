extends IControllerKeyPressed

func _ready():
	key = MOUSE_BUTTON_RIGHT
	coltdown_time = 1
	await super._ready()
			
func active():
	$aa_ranger_m.active()
	coltdown.start()
