extends IControllerKeyPressed

func _ready():
	key = ServiceSettings.keys_values['key_ultimate']
	coltdown_time = 13
	await super._ready()

func active():
	await super.active()
	$dp_healer_f_4.get_children().filter(func(c): return c is IActive).map(func(heal): heal.active()) 

