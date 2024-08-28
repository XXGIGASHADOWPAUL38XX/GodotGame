extends IControllerKeyPressed

func after_ready():
	key = KEY_SPACE
	coltdown_time = 13
	await super.after_ready()

func active():
	super.active()
	$dp_healer_f_4.get_children().filter(func(c): return c is IActive).map(func(heal): heal.can_active()) 

