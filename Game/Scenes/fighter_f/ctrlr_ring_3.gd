extends IControllerKeyPressed

var zone_b4pulse
var pulse

func _ready():
	key = KEY_E
	coltdown_time = 8
	await super._ready()
	
	zone_b4pulse = $zone_b4pulse
	pulse = $pulse

func active():
	zone_b4pulse.active(get_global_mouse_position())
	coltdown.start()
