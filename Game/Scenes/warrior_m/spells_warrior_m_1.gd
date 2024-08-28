extends IControllerKeyPressed

func after_ready():
	if is_multiplayer_authority():
		key = KEY_A
		coltdown_time = 4
		await super.after_ready()
			
func active():
	super.active()
	coltdown.start()
	var angle = (get_global_mouse_position() - $spells_warrior_m_1_1.champion.position).angle()
	
	$spells_warrior_m_1_1.can_active(angle)
	await get_tree().create_timer(0.5).timeout
	
	$spells_warrior_m_1_2.can_active(angle)
	await get_tree().create_timer(0.5).timeout
	
	$spells_warrior_m_1_3.can_active(angle)
