extends "res://Game/Interface/IHoldableCounter.gd"

var champion
var animation 

func _ready():
	if is_multiplayer_authority():
		animation = $special_ninja_m_anim
		animation.animation = 'default'
		animation.animation_changed.connect(func(a) : 
			HAS_DMG_EFFECT = a == 'dash'
			self.modulate = 1 if a == 'dash' else 0
		)
		
		cd_spell = 10
		coltdown_spell = service_time.init_timer(self, cd_spell)
		timer_key_release_cd = 0.5
		key = KEY_D

		champion = ServiceScenes.championNode
		super._ready()
		
		func_on_entity_entered.append(Callable(self, 'dash'))

func _process(_delta):
	if is_multiplayer_authority():
		super._process(_delta)
		
		if self.visible:
			self.rotate(deg_to_rad(1))
			self.position = champion.position
			
#		if (HUD == null):
#			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
#		else:
#			HUD.bindTo(coltdown_spell, 3)

func start_spell():
	print(1)
	animation.play("default")
	self.show()
	champion.set_attribute('state_damage', State.StateDamage.IMMUNE)
	champion.set_attribute('state_movement', State.StateMovement.IMMOBILE)
	
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

func dash():
	self.position = champion.position + ServiceSpell.set_in_front(champion, 10)
	self.show()
	self.rotation = (get_global_mouse_position() - self.position).angle()

	animation.play("dash")

	for i in range(20):
		champion.position = champion.position + ServiceSpell.set_in_front(champion, 5)
		self.position = champion.position + ServiceSpell.set_in_front(champion, 10)
		await get_tree().create_timer(0).timeout

	animation.stop()
	self.hide()

