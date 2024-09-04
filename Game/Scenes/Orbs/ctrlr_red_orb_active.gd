extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_active_item']
		coltdown_time = 12
		cast_time = ServiceSpell.animation_duration($red_orb_active/animation_dash)
		await super._ready()

func active():
	await super.active()
	$red_orb_active.active()
