extends IControllerKeyPressed

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		key = KEY_E
		coltdown_time = 6
		
		await super.after_ready()

func active():
	super.active()
	$damage.can_active()
	
