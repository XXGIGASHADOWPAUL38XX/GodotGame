extends IControllerHoldable

var counter
var push

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_special']
		coltdown_time = 7
		timer_key_release_cd = 10
		
		counter = $counter_tank_m
		push = $push_tank_m
		
		await super._ready()

func active():
	await super.active()
	counter.active()

func stop_spell():
	super.stop_spell()
	counter.stop_spell()

