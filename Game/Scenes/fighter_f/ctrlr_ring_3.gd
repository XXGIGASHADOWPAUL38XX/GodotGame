extends IControllerKeyPressed

var zone_b4pulse
var pulse
var anim_strike

func _ready():
	key = ServiceSettings.keys_values['key_spell_3']
	coltdown_time = 8
	cast_time = 0.5
	await super._ready()
	
	zone_b4pulse = $zone_b4pulse
	pulse = $pulse
	anim_strike = $anim_strike

func active():
	var mouse_position = get_global_mouse_position()
	await super.active()
	
	await zone_b4pulse.active(mouse_position)
	
	pulse.active(mouse_position)
	anim_strike.active()
	
	
