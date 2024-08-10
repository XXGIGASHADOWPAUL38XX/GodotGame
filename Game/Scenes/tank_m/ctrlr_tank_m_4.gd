extends IControllerKeyPressed

var charge
var zone

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = KEY_SPACE
		coltdown_time = 14
		
		charge = $charge
		zone = $zone
		
		await super._ready()

func active():
	coltdown.start()
	charge.active()
	zone.active()
