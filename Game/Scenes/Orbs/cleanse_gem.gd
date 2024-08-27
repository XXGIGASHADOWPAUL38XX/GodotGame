extends AnimatedSprite2D

func _ready():
	if is_multiplayer_authority():
		self.modulate.a = 1
		
		await self._ready()

func active():
	ServiceScenes.championNode.state = State.StateAction.NULL
	self.play("default")
	self.show()
	await get_tree().create_timer(0.3).timeout
	
	for i in range(10):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0).timeout
		
	self.hide()
	self.modulate.a = 1
