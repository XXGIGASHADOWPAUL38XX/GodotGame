extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = KEY_F
		coltdown_time = 12
		cast_time = ServiceSpell.animation_duration($red_orb_active/animation_dash)
		await super._ready()

func active():
	super.active()
	$red_orb_active.can_active()
