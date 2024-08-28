extends IControllerHoldable

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		key = KEY_D
		coltdown_time = 7
		timer_key_release_cd = 0.75
		
		await super.after_ready()

func active():
	super.active()
	$special_warrior_m.can_active()

func stop_spell():
	super.stop_spell()
	$special_warrior_m.stop_spell()

