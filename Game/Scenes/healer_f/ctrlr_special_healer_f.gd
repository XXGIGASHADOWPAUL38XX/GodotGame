extends IControllerKeyPressed

var purges

func _ready():
	key = ServiceSettings.keys_values['key_special']
	coltdown_time = 8
	await super._ready()
	
	purges = $dp_special_healer_f.get_children().filter(func(c): return c is IActive)

func active():
	await super.active()
	purges.map(func(purge): purge.active()) 

