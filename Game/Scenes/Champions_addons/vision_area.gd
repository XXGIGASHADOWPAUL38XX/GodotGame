extends IVisionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	return
	if is_multiplayer_authority():
		super._ready()
