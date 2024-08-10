extends IControllerKeyPressed

func _ready():
	key = KEY_SPACE
	coltdown_time = 13
	await super._ready()

func active():
	coltdown.start()
	$dp_healer_f_4.get_children().filter(func(c): return c is IActive).map(func(heal): heal.active()) 

