extends IControllerHoldable

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = KEY_D
		coltdown_time = 7
		timer_key_release_cd = 0.75
		
		await super._ready()

func active():
	$special_tank_m.active()

func stop_spell():
	super.stop_spell()
	$special_tank_m.stop_spell()
