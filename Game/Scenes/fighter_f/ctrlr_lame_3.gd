extends IControllerKeyPressed

var lames

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_3']
		coltdown_time = 6
		await super._ready()
		
		lames = $dp_lame_3.get_children().filter(func(lame) : return lame is IActive)

func active():
	await super.active()
	lames.map(func(lame): lame.active())
	
