extends IControllerSpell

func _ready():
	key = KEY_Z
	coltdown_time = 6
	await super._ready()

func active():
	var main_vector = get_global_mouse_position() - ServiceScenes.championNode.position
	
	# Les tirs
	spells.filter(func(s): return s.name.begins_with("throw")).map(func(s): s.can_active(main_vector))
	
	# Les autres sorts (le dash)
	spells.filter(func(s): return !s.name.begins_with("throw")).map(func(s): s.can_active())
	
	coltdown.start()
