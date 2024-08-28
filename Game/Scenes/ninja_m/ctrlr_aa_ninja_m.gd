extends IControllerKeyPressed

func _ready():
	key = MOUSE_BUTTON_RIGHT
	coltdown_time = 1
	await super._ready()
			
func active():
	super.active()
	$aa_ninja_m.can_active()
	
