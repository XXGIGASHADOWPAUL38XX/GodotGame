extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_2']
		coltdown_time = 6
		cast_time = 0.1
				
		await super._ready()

func active():
	await super.active()
	var spell_position = ServiceSpell.distance_range_max(
		ServiceScenes.championNode.position, get_global_mouse_position(), 300
	)
	
	$anim_zone.active(spell_position)
	
	await $zone.active(spell_position)
	$anim_zone.desactive()
