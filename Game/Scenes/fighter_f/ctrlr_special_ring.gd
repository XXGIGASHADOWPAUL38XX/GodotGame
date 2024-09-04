extends IControllerHoldable

var special_ring
var special_pulse

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_special']
		coltdown_time = 7
		timer_key_release_cd = 0.75
		
		await super._ready()
		
		special_ring = $special_ring
		special_pulse = $special_pulse

func active():
	await super.active()
	special_ring.active()

func stop_spell():
	super.stop_spell()
	special_ring.stop_spell()

