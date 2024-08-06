extends IControllerSpell

var rock
var explode

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = KEY_E
		coltdown_time = 6
		
		rock = $spells_tank_m_3/rock_tank_m_3
		explode = $spells_tank_m_3/explode_tank_m_3
		
		await super._ready()

func active():
	coltdown.start()
	rock.active()
