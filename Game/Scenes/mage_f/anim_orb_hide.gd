extends IAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		await super._ready()
		self.frame_changed.connect(func(): self.modulate.a = min(1, 1.3 - (self.frame * 0.2)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active():
	self.position = spell_controller.orb.position
	self.play()
	self.show()
	
	await self.animation_finished
	self.hide()
	self.modulate.a = 1
