extends ICounter

func _ready():
	if is_multiplayer_authority():
		self.modulate.a = 0
		await super._ready()
		
		#!!
		await ServiceEvents.await_event(func f(): return champion != null)
		func_on_spell_entered.append(Callable(spell_controller.cube_special, 'active'))

func _process(_delta):
	if is_multiplayer_authority():
		super._process(_delta)
			
		if self.visible:
			self.rotate(deg_to_rad(1))
			self.position = champion.position

func active():
	self.show()
	champion.add_state(self, 'states_damage', State.StateDamage.IMMUNE)
	champion.add_state(self, 'states_action', State.StateAction.IMMOBILE)
	
	for i in range(5):
		self.modulate.a += 0.1
		await get_tree().create_timer(0).timeout

func stop_spell():
	for i in range(5):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.0).timeout

	champion.remove_state(self, 'states_damage')
	champion.remove_state(self, 'states_action')
	self.hide()