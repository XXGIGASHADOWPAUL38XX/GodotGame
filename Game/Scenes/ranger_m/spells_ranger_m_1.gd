extends IControllerSpell

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_1']
		coltdown_time = 4
		cast_time = 0.1
		await super._ready()

func active():
	var main_vector = get_global_mouse_position() - ServiceScenes.championNode.position
	
	# Les tirs
	spells.filter(func(s): return s.name.begins_with("throw")).map(func(s): s.active(main_vector))
	
	coltdown.start()
