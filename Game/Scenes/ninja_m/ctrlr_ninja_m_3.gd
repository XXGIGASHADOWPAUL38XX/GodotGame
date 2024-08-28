extends IControllerKeyPressed

var dashes_shadows

func after_ready():
	if is_multiplayer_authority():
		key = KEY_E
		coltdown_time = 8
		await super.after_ready()
		
		dashes_shadows = $dp_dashes_shadows.get_children().filter(func(c): return c is IActive)

func active():
	super.active()
	var endpoint_dash = ServiceSpell.distance_range_max(ServiceScenes.championNode.position, get_global_mouse_position(), 100)
	var main_vector = endpoint_dash - ServiceScenes.championNode.position
	
	await dashes_shadows.map(func(dash): await dash.can_active(main_vector))
	

