extends IControllerKeyPressed

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = KEY_E
		coltdown_time = 6
		
		await super._ready()

func active():
	super.active()
	$damage.active()
	
