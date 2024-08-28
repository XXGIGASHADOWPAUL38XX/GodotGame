extends IControllerKeyPressed

var shoots

func _ready():
	if is_multiplayer_authority():
		key = KEY_SPACE
		coltdown_time = 12
		await super._ready()
		
		shoots = $dp_spell_4.get_children().filter(func(s): return s is IActive)

func active():
	super.active()
	shoots.map(func(s): s.can_active())
