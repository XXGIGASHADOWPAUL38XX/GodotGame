extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = KEY_SPACE
		coltdown_time = 8
		await super._ready()

func active():
	$change_weapon.active()
