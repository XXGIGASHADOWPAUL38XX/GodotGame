extends IControllerKeyPressed

func _ready():
	key = MOUSE_BUTTON_RIGHT
	coltdown_time = 1
	await super._ready()
			
func active():
	super.active()
	$aa_healer_f.active()
	
