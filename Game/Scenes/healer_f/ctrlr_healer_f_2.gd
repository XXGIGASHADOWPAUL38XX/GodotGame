extends IControllerKeyPressed

func _ready():
	key = KEY_Z
	coltdown_time = 6
	await super._ready()

func active():
	super.active()
	$spells_healer_f_2.can_active()

