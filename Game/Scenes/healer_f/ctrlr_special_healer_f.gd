extends IControllerKeyPressed

var purges

func _ready():
	key = KEY_D
	coltdown_time = 8
	await super._ready()
	
	purges = $dp_special_healer_f.get_children().filter(func(c): return c is IActive)

func active():
	super.active()
	purges.map(func(purge): purge.active()) 

