extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = MOUSE_BUTTON_RIGHT
		coltdown_time = 1
		
		await super._ready()
			
func active():
	super.active()
	$aa_warrior_m.can_active()
