extends IControllerKeyPressed

var rock
var explode

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_3']
		coltdown_time = 6
		cast_time = 0.2
		cast_kind = CastTime.Kind.BeforeActive
		
		rock = $spells_tank_m_3/rock_tank_m_3
		explode = $spells_tank_m_3/explode_tank_m_3
		
		await super._ready()

func active():
	await super.active()
	rock.active()
