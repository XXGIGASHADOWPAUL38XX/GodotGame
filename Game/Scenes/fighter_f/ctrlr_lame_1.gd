extends IControllerKeyPressed

var champion

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_1']
		coltdown_time = 2
		await super._ready()
		
		champion = ServiceScenes.championNode

func active():
	await super.active()
	var base_destination = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 250)
	
	$lame_1.active(base_destination)
	await get_tree().create_timer(0.25).timeout
	$lame_2.active(base_destination)
