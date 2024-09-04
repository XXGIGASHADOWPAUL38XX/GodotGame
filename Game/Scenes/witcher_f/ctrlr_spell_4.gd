extends IControllerKeyPressed

var zone_ult 
var cubes

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_ultimate']
		coltdown_time = 13
		
		zone_ult = $zone_ult
		
		await super._ready()
		cubes = $dp_cube_4.get_children().filter(func(c): return c is CharacterBody2D)
		
		zone_ult.duration_timer.timeout.connect(func():
			zone_ult.hide()
			cubes.map(func(c): c.hide())
		)

func active():
	await super.active()
	zone_ult.active()
	cubes.map(func(c): c.active())
