extends ICounter

func _ready():
	if is_multiplayer_authority():
		self.modulate.a = 0
		await super._ready()
		
		#!!
		await ServiceEvents.await_event(func f(): return champion != null)
		func_on_spell_entered.append(Callable(self, 'special_pulse'))
		
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
		
func special_pulse():
	spell_controller.special_pulse.can_active()
