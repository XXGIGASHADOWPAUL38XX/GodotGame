extends IControllerSpell

func _ready():
	key = KEY_A
	coltdown_time = 4
	await super._ready()
			
func active():
	coltdown.start()
	var angle = (get_global_mouse_position() - $spells_warrior_m_1_1.champion.position).angle()
	
	$spells_warrior_m_1_1.active(angle)
	await get_tree().create_timer(0.5).timeout
	
	$spells_warrior_m_1_2.active(angle)
	await get_tree().create_timer(0.5).timeout
	
	$spells_warrior_m_1_3.active(angle)
