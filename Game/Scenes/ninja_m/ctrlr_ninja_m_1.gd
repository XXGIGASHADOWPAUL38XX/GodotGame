extends IControllerKeyPressed

var shuriken
var dash
var shadow

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_1']
		coltdown_time = 5
		
		shuriken = $spell_ninja_m_1/shuriken_m_1
		shadow = $spell_ninja_m_1/shadow_m_1
		
		await super._ready()

func active():
	await super.active()
	shadow.hide()
	await shuriken.active()
	shadow.active(shuriken)
	
