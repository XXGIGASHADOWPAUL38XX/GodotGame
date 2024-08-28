extends IAnimation

# Called when the node enters the scene tree for the first time.
func after_ready():
	self.frame = 0
	await super.after_ready()
	
	self.frame_changed.connect(func():
		if self.frame > 0:
			self.show()
		else:
			self.hide()
	)

func _process(delta):
	if is_multiplayer_authority():
		self.position = Vector2(
			ServiceScenes.championNode.position.x,
			ServiceScenes.championNode.position.y - 60
		)
