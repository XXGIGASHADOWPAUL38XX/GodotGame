extends ICounter

func _ready():
	if is_multiplayer_authority():
		await super._ready()

		func_on_spell_entered.append(Callable(spell_controller.dash, 'active'))

func _process(_delta):
	if is_multiplayer_authority():
		if self.visible:
			self.rotate(deg_to_rad(1))
			self.position = champion.position

func active():
	animation.play()
	self.show()
	
	for i in range(5):
		self.modulate.a += 0.1
		await get_tree().create_timer(0).timeout

func stop_spell():
	for i in range(5):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.0).timeout

	self.hide()

