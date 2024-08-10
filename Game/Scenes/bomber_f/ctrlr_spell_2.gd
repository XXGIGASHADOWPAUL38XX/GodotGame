extends IControllerKeyPressed

var duplicated_spells

func _ready():
	if is_multiplayer_authority():
		key = KEY_Z
		coltdown_time = 8
		
		await super._ready()
		duplicated_spells = $dp_spell_2.get_children()

func active():
	coltdown.start()
	duplicated_spells.map(func(ds): ds.active())

