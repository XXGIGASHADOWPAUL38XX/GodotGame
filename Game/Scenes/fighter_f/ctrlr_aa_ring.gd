extends IControllerKeyPressed

func _ready():
	key = MOUSE_BUTTON_RIGHT
	coltdown_time = 0.8
	await super._ready()
			
func active():
	$aa_ring.active()
	coltdown.start()