extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = KEY_Z
		coltdown_time = 6
		
		await super._ready()

func active():
	super.active()
	$dash.active()
	await get_tree().create_timer(0.5).timeout
	$dash.active()

