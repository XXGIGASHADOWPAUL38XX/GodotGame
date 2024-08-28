extends IControllerKeyPressed

var spell_1
var spell_2

var champion

func after_ready():
	if is_multiplayer_authority():
		key = KEY_A
		coltdown_time = 6
		
		champion = ServiceScenes.championNode
		spell_1 = $spells_healer_f_1_1
		spell_2 = $spells_healer_f_1_2
		
		await super.after_ready()

func active():
	super.active()
	var destination_point = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 400)
	var main_vector = destination_point - self.position
	
	spell_1.can_active(destination_point, main_vector)
	await get_tree().create_timer(0.25).timeout
	spell_2.can_active(destination_point, main_vector)
	
