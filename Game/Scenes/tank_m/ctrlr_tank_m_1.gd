extends IControllerKeyPressed

var spell

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_1']
		coltdown_time = 5
		
		spell = $spell_tank_m_1
		
		await super._ready()

func active():
	await super.active()
	spell.active()
