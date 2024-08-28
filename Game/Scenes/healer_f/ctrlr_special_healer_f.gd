extends IControllerKeyPressed

var purges

func after_ready():
	key = KEY_D
	coltdown_time = 8
	await super.after_ready()
	
	purges = $dp_special_healer_f.get_children().filter(func(c): return c is IActive)

func active():
	super.active()
	purges.map(func(purge): purge.can_active()) 

