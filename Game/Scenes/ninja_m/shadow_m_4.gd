extends ICollision

var is_shadow = true

func _ready():
	if is_multiplayer_authority():
			super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active(shuriken):
	self.position = shuriken.position
	self.show()
	
func is_active():
	return self.visible
	
func has_been_dashed_to():
	self.hide()
	
func dash():
	pass
