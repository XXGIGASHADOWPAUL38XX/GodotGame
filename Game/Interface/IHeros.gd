extends ICharacter

class_name IHeros

func _ready():
	if is_multiplayer_authority():
		shield = $shield
		await super._ready()
		
	if ServiceScenes.get_property_from_player(self, '.is_ally()') == true:
		self.health_bar.modulate = Color.YELLOW
	elif !is_multiplayer_authority():
		self.health_bar.modulate = Color.RED
		
func _process(delta):
	if is_multiplayer_authority():
		ServiceMovements.move(self, animation, speed_final * delta)	
		ServiceHealth.setBar(self, $health_bar)
	
func take_damage():
	if state_damage == State.StateDamage.IMMUNE:
		return

	var output_damage = last_spell_hitting.output_damage.call(self)
		
	if output_damage > 0:
		if state_shielded == State.StateShielded.SHIELDED:
			output_damage = shield.remaining_damage(output_damage)		
		ServiceAnimations.set_animation(self, 'animation_hitted')
	else:
		ServiceAnimations.set_animation(self, 'animation_healed')
		
	self.state_movement = state_movement
	self.health_bar.value -= output_damage
		
	var color = Color.GREEN if output_damage < 0 else Color.RED
			
	for i in range(2):
		self.animation.modulate = color
		await get_tree().create_timer(0.15).timeout
		self.animation.modulate = Color.WHITE
		await get_tree().create_timer(0.15).timeout

func set_multiplayer_properties():
	super.set_multiplayer_properties()
	var shld_bar_path = self.name + "/shield"
	
	multip_sync.replication_config.add_property(shld_bar_path + ":position")
	multip_sync.replication_config.add_property(shld_bar_path + ":size")
