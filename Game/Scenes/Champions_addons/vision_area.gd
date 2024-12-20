extends IVisionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		super._ready()
