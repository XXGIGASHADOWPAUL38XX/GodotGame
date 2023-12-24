extends "res://Game/Interface/IHoldableCounter.gd"

var champion

func _ready():
	if is_multiplayer_authority():
		cd_spell = 10
		spell = $Spells_warrior_anim_4
		coltdown_spell = service_time.init_timer(self, cd_spell)
		timer_key_release_cd = 0.5
		key = KEY_D

		champion = ServiceScenes.championNode
		self.modulate.a = 0
		super._ready()
		
		func_on_entity_entered.append(Callable(self, 'boost_zone_entered'))
		func_on_entity_exited.append(Callable(self, 'boost_zone_exited'))

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
	champion.set_attribute('state_movement', State.StateMovement.IMMOBILE)
	self.hide()

func boost_zone_entered():
	self.position += (get_global_mouse_position() - self.position).normalized() * 50

func get_all_ennemies_spells(node):
	var spells = []
	if node is Area2D && node.name.begins_with('spell'):
		spells.append(node)
	else:
		for child in node.get_children():
			var child_spells = get_all_ennemies_spells(child)
			spells += child_spells

	return spells
