extends IControllerKeyPressed

func after_ready():
	key = MOUSE_BUTTON_RIGHT
	coltdown_time = 1
	await super.after_ready()
			
func active():
	super.active()
	$aa_tank_m.can_active()
	
