extends IControllerHoldable

var counter
var dash

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_special']
		coltdown_time = 7
		timer_key_release_cd = 0.75
		
		counter = $counter_mage_f
		dash = $dash
		
		await super._ready()

func active():
	await super.active()
	counter.active()

func stop_spell():
	super.stop_spell()
	counter.stop_spell()

