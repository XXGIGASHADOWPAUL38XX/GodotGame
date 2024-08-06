extends IHoldableCounter

var animation: AnimatedSprite2D

func _ready():
	if is_multiplayer_authority():
		animation = $AnimatedSprite2D
		animation.animation = 'default'
		animation.scale = Vector2(0.06, 0.06)
		animation.animation_changed.connect(func() : 
			HAS_DMG_EFFECT = animation.animation == 'explode'
			self.modulate = 1 if animation.animation == 'explode' else 0
		)
		
		cd_spell = 10
		spell = $Spells_warrior_anim_4
		coltdown_spell = service_time.init_timer(self, cd_spell)
		timer_key_release_cd = 0.5
		key = KEY_D
		

		champion = ServiceScenes.championNode
		self.modulate.a = 0
		await super._ready()
		
		func_on_spell_entered.append(Callable(self, 'explode'))

func _process(_delta):
	if is_multiplayer_authority():
		super._process(_delta)
			
#		if (HUD == null):
#			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
#		else:
#			HUD.bindTo(coltdown_spell, 3)
			
		if self.visible:
			self.rotate(deg_to_rad(1))
			self.position = champion.position

func start_spell():
	self.show()
	champion.set_attribute('state_damage', State.StateDamage.IMMUNE)
	champion.set_attribute('state_damage', State.StateMovement.IMMOBILE)
	
	for i in range(5):
		self.modulate.a += 0.1
		await get_tree().create_timer(0).timeout

func stop_spell():
	super.stop_spell()
	
	for i in range(5):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.0).timeout

	champion.set_attribute('state_damage', State.StateDamage.NULL)
	champion.set_attribute('state_movement', State.StateMovement.NULL)
	self.hide()

func explode():
	animation.play('explode')
	for i in range(15):
		animation.scale += Vector2(0.01, 0.01)
		await get_tree().create_timer(0.01).timeout
	
	animation.scale = Vector2(0.06, 0.06)
	animation.play('default')
	await coltdown_spell.timeout
