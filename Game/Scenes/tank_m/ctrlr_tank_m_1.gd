extends IControllerSpell

var spell

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = KEY_A
		coltdown_time = 5
		
		spell = $spell_tank_m_1
		
		await super._ready()

func active():
	coltdown.start()
	spell.active()
