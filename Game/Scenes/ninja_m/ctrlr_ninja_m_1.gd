extends IControllerKeyPressed

var shuriken
var dash
var shadow

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = KEY_A
		coltdown_time = 5
		
		shuriken = $spell_ninja_m_1/shuriken_m_1
		shadow = $spell_ninja_m_1/shadow_m_1
		
		await super._ready()

func active():
	super.active()
	
	shadow.hide()
	await shuriken.can_active()
	shadow.can_active(shuriken)
