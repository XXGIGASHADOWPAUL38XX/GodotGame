extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_1']
		coltdown_time = 4
		
		cast_time = 0.1
		
		await super._ready()
			
func active():
	await super.active()
	var angle = (get_global_mouse_position() - $spells_warrior_m_1_1.champion.position).angle()
	
	$spells_warrior_m_1_1.active(angle)
	await get_tree().create_timer(0.5).timeout
	
	$spells_warrior_m_1_2.active(angle)
	await get_tree().create_timer(0.5).timeout
	
	$spells_warrior_m_1_3.active(angle)
