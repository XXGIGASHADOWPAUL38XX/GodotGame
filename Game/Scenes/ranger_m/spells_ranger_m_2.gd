extends IControllerSpell

func _ready():
	key = ServiceSettings.keys_values['key_spell_2']
	coltdown_time = 6
	await super._ready()

func active():
	var main_vector = get_global_mouse_position() - ServiceScenes.championNode.position
	
	# Les tirs
	spells.filter(func(s): return s.name.begins_with("throw")).map(func(s): s.active(main_vector))
	
	# Les autres sorts (le dash)
	spells.filter(func(s): return !s.name.begins_with("throw")).map(func(s): s.active())
	
	coltdown.start()
