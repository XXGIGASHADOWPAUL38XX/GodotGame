extends IControllerKeyPressed

var charge
var zone

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_ultimate']
		coltdown_time = 14
		cast_time = 0.2
		cast_kind = CastTime.Kind.BeforeActive
		
		charge = $charge
		zone = $zone
		
		await super._ready()

func active():
	await super.active()
	charge.active()
	zone.active()
