extends IControllerHoldable

var spell

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_2']
		coltdown_time = 7
		timer_key_release_cd = 2
		
		spell = $spell_tank_m_2
		
		await super._ready()

func active():
	await super.active()
	spell.active()

func stop_spell():
	super.stop_spell()
	spell.stop_spell()
