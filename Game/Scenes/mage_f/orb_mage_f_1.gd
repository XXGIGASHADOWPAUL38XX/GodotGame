extends ICollision

func _ready():
	if is_multiplayer_authority():
		await super._ready()
		
		self.visibility_changed.connect(func():
			if self.visible:
				animation.play()
			else:
				animation.stop()
		)

func _process(delta):
	if is_multiplayer_authority():
		pass
		
func active():
	self.position = spell_controller.spell_orb.position
	self.show()

func unactive():
	self.hide()
	#for i in range(10):
		#self.modulate.a -= 0.1
		#await get_tree().create_timer(0).timeout
	#
	#self.hide()
	#self.modulate.a = 1

