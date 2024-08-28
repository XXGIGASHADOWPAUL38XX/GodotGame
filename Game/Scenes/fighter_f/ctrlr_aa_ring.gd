extends IControllerKeyPressed

func after_ready():
	key = MOUSE_BUTTON_RIGHT
	coltdown_time = 0.8
	await super.after_ready()
			
func active():
	super.active()
	$aa_ring.can_active()
	
