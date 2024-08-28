extends IControllerKeyPressed

var zone_b4pulse
var pulse

func after_ready():
	key = KEY_E
	coltdown_time = 8
	await super.after_ready()
	
	zone_b4pulse = $zone_b4pulse
	pulse = $pulse

func active():
	super.active()
	zone_b4pulse.can_active(get_global_mouse_position())
	
