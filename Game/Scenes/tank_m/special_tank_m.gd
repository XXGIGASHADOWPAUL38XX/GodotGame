extends ICounter

var animation 

func _ready():
	if is_multiplayer_authority():
		animation = $special_tank_m_anim
		animation.animation = 'default'
		animation.animation_changed.connect(func(a) : 
			HAS_DMG_EFFECT = a == 'dash'
			self.modulate = 1 if a == 'dash' else 0
		)

		await super._ready()
		
		func_on_spell_entered.append(Callable(self, 'dash'))

func _process(_delta):
	if is_multiplayer_authority() && self.visible:
		self.rotate(deg_to_rad(1))
		self.position = champion.position

func active():
	animation.play("default")
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

func dash():
	self.position = champion.position + ServiceSpell.set_in_front(champion, 10)
	self.show()
	self.rotation = (get_global_mouse_position() - self.position).angle()

	animation.play("dash")

	for i in range(25):
		champion.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 4)
		self.position = champion.position + ServiceSpell.set_in_front(champion, 10)
		await get_tree().create_timer(0).timeout

	animation.stop()
	self.hide()

