extends IControllerHoldable

var special
var cube_special

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_special']
		coltdown_time = 7
		timer_key_release_cd = 0.75
				
		special = $special
		cube_special = $cube_special
		
		await super._ready()

func active():
	await super.active()
	special.active()

func stop_spell():
	super.stop_spell()
	special.stop_spell()
