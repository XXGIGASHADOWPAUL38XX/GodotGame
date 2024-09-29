extends IControllerKeyPressed

var shoots

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_ultimate']
		coltdown_time = 12
		cast_time = 0.1
		await super._ready()
		
		shoots = $dp_spell_4.get_children().filter(func(s): return s is IActive)

func active():
	await super.active()
	shoots.map(func(s): s.active())
