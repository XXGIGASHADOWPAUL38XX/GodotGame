extends IControllerKeyPressed

var zone_b4pulse
var pulse

func _ready():
	key = ServiceSettings.keys_values['key_spell_3']
	coltdown_time = 8
	cast_time = 0.5
	await super._ready()
	
	zone_b4pulse = $zone_b4pulse
	pulse = $pulse

func active():
	await super.active()
	zone_b4pulse.active(get_global_mouse_position())
	
