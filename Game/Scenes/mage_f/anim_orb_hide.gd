extends IAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		await super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active():
	self.position = spell_controller.orb.position
	self.play()
	self.show()
	
	await self.animation_finished
	self.hide()
