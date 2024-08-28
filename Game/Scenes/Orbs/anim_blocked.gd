extends IAnimation

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		await super.after_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active(spell):
	self.position = spell.position
	self.play()
	self.show()
	
	await self.animation_finished
	self.hide()
