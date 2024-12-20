extends IAnimableVisionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		await super._ready()

func active():
	pass
