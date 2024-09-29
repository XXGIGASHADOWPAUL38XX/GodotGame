extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = MOUSE_BUTTON_RIGHT
		coltdown_time = 1
		
		cast_time = 0.1
		
		await super._ready()
			
func active():
	await super.active()
	$aa_warrior_m.active()
