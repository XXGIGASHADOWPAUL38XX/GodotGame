extends IControllerKeyPressed

func _ready():
	key = MOUSE_BUTTON_RIGHT
	coltdown_time = 0.8
	cast_time = 0.1
	await super._ready()
			
func active():
	await super.active()
	$aa_lames_1.active()
	await get_tree().create_timer(0.25).timeout
	$aa_lames_2.active()
	
	
