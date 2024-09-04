extends IControllerKeyPressed

var dashes_shadows

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_3']
		coltdown_time = 8
		await super._ready()
		
		dashes_shadows = $dp_dashes_shadows.get_children().filter(func(c): return c is IActive)

func active():
	await super.active()
	var endpoint_dash = ServiceSpell.distance_range_max(ServiceScenes.championNode.position, get_global_mouse_position(), 100)
	var main_vector = endpoint_dash - ServiceScenes.championNode.position
	
	await dashes_shadows.map(func(dash): await dash.active(main_vector))
	

