extends IControllerKeyPressed

func _ready():
	key = KEY_Z
	coltdown_time = 6
	await super._ready()

func active():
	coltdown.start()
	$spells_healer_f_2.active()

