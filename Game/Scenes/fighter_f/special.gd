extends ICounter

func _ready():
	if is_multiplayer_authority():
		self.modulate.a = 0
		await super._ready()
		
		func_on_spell_entered.append(Callable(self, 'special_dashes'))

func _process(_delta):
	if is_multiplayer_authority():
		super._process(_delta)
			
		if self.visible:
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

func special_dashes():
	spell_controller.special_dashes.map(func(lame): lame.active())
	
	await get_tree().create_timer(0.5).timeout
	var closest_lame = spell_controller.special_dashes.reduce(func(a, b): return a if a.position.distance_to(
		get_global_mouse_position()) < b.position.distance_to(get_global_mouse_position()) else b
	)
	spell_controller.special_dashes.map(func(lame): lame.second_active(closest_lame))
	
