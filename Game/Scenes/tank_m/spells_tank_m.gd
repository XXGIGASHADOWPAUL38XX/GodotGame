extends IPlaceholderSpells

var rocks
var explode 

# Called when the node enters the scene tree for the first time.
func _ready():
	await super._ready()
	
	if is_multiplayer_authority():
		rocks = [$ctrlr_tank_m_3/spells_tank_m_3/rock_tank_m_3]
		explode = $ctrlr_tank_m_3/spells_tank_m_3/explode_tank_m_3
