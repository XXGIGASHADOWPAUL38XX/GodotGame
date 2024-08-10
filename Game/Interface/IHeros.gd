extends ICharacter

class_name IHeros

var target_position_mvmt = Vector2.ZERO
var angle_mvmt

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
		move()
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
	
func move():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		target_position_mvmt = get_global_mouse_position()
		
	self.direction = (target_position_mvmt - self.position).normalized()
	self.velocity = self.direction * speed_final
	
	if (self.state_movement == State.StateMovement.SLOWED):
		self.velocity *= 0.5
	elif (self.state_movement == State.StateMovement.STUNNED or self.state_movement == State.StateMovement.IMMOBILE):
		self.velocity *= 0
	
	self.move_and_collide(self.velocity)

	play_movement_animation(animation)
	#await get_tree().create_timer(0.05).timeout
	
func play_movement_animation(animation):
	angle_mvmt = rad_to_deg(self.direction.angle())
	if angle_mvmt >= -45 && angle_mvmt <= 45:
		animation.play("walk_right")
	elif angle_mvmt >= 45 && angle_mvmt <= 135:
		animation.play("walk_down")
	elif angle_mvmt >= 135 || angle_mvmt <= -135:
		animation.play("walk_left")
	else:
		animation.play("walk_up")
