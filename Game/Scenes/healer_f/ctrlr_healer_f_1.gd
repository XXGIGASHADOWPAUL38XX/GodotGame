extends IControllerSpell

var mark_stun_anim
var spell_1
var spell_2

func _ready():
	if is_multiplayer_authority():
		key = KEY_A
		coltdown_time = 6
		
		mark_stun_anim = $mark_stun
		spell_1 = $spells_healer_f_1_1
		spell_2 = $spells_healer_f_1_2
		
		await super._ready()

func active():
	coltdown.start()
	
	spell_1.active()
	await get_tree().create_timer(0.25).timeout
	spell_2.active()
	
