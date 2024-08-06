extends IControllerSpell

func _ready():
	if is_multiplayer_authority():
		key = KEY_Z
		coltdown_time = 6
		
		await super._ready()

func active():
	$zone.active()
