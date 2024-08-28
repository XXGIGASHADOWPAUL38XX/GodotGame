extends ICounter

func after_ready():
	if is_multiplayer_authority():
		self.modulate.a = 0
		await super.after_ready()
		
		func_on_spell_entered.append(Callable(self, 'explode'))
		
		animation.animation = 'default'
					
		animation.scale = Vector2(0.06, 0.06)
		animation.animation_changed.connect(func() : 
			HAS_DMG_EFFECT = animation.animation == 'explode'
			self.modulate = 1 if animation.animation == 'explode' else 0
		)

func _process(_delta):
	if is_multiplayer_authority() && self.visible:
		self.rotate(deg_to_rad(1))
		self.position = champion.position

func active():
	self.show()
	
	for i in range(5):
		self.modulate.a += 0.1
		await get_tree().create_timer(0).timeout

func stop_spell():
	for i in range(5):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.0).timeout

	self.hide()

func explode():
	animation.play('explode')
	for i in range(15):
		animation.scale += Vector2(0.01, 0.01)
		await get_tree().create_timer(0.01).timeout
	
	animation.scale = Vector2(0.06, 0.06)
	animation.play('default')
