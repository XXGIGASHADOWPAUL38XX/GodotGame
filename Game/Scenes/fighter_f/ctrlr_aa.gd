extends IControllerKeyPressed

func after_ready():
	key = MOUSE_BUTTON_RIGHT
	coltdown_time = 0.8
	await super.after_ready()
			
func active():
	super.active()
	$aa_lames_1.can_active()
	await get_tree().create_timer(0.25).timeout
	$aa_lames_2.can_active()
	
