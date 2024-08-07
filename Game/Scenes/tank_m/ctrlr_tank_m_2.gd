extends IControllerHoldable

var spell

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = KEY_Z
		coltdown_time = 7
		timer_key_release_cd = 0.75
		
		spell = $spell_tank_m_2
		
		await super._ready()

func active():
	coltdown.start()
	spell.active()

func stop_spell():
	super.stop_spell()
	spell.stop_spell()
