extends IControllerHoldable

var special_ring
var special_pulse

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		key = KEY_D
		coltdown_time = 7
		timer_key_release_cd = 10
		
		await super.after_ready()
		
		special_ring = $special_ring
		special_pulse = $special_pulse

func active():
	super.active()
	special_ring.can_active()

func stop_spell():
	super.stop_spell()
	special_ring.stop_spell()

