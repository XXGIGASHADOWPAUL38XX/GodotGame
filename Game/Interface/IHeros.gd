extends ICharacter

class_name IHeros

var path = []
var angle_mvmt

var map: RID
var naviguation_region: RID
var avoid_fpath = false

const POSITION_OFFSET_SPAWN = 100

func _ready():
	await super._ready()
	if is_multiplayer_authority():
		map = NavigationServer2D.map_create()
		NavigationServer2D.map_set_cell_size(map, speed_final)
		NavigationServer2D.map_set_active(map, true)
		naviguation_region = ServiceScenes.naviguation_region
		NavigationServer2D.region_set_map(naviguation_region, map)
		
		NavigationServer2D.map_force_update(map)
	
	shield = $pgbars/shield
		
	if !is_multiplayer_authority():
		if ServiceScenes.is_on_same_team(self, ServiceScenes.championNode):
			self.health_bar.modulate = Color.YELLOW
		else:
			self.health_bar.modulate = Color.RED
		
func _process(delta):
	if is_multiplayer_authority():
		move()
	
func take_damage():
	if curr_state_damage.state == State.StateDamage.IMMUNE:
		return

	var output_damage = last_spell_hitting.output_damage.call(self)
	if output_damage > 0 && last_spell_hitting.state_action != State.StateAction.NULL:
		set_state_action()
		
	if output_damage > 0:
		if curr_state_shielded.state == State.StateShielded.SHIELDED:
			output_damage = shield.remaining_damage(output_damage)
		ServiceAnimations.set_animation(self, 'animation_hitted')
	else:
		ServiceAnimations.set_animation(self, 'animation_healed')
		
	self.curr_state_action = curr_state_action
	self.health_bar.value -= output_damage
	
	check_if_allies_dead()
		
	var color = Color.GREEN if output_damage < 0 else Color.RED
			
	for i in range(2):
		self.modulate = color
		await get_tree().create_timer(0.15).timeout
		self.modulate = Color.WHITE
		await get_tree().create_timer(0.15).timeout

func check_if_allies_dead():
	if ServiceScenes.alliesNode.all(func(ally): return ally.health_bar.value == 0):
		ServiceRounds.new_round_global(self)

func set_multiplayer_properties():
	await super.set_multiplayer_properties()
	var shld_bar_path = self.name + "/pgbars/shield"
	
	multip_sync.replication_config.add_property(shld_bar_path + ":position")
	multip_sync.replication_config.add_property(shld_bar_path + ":visible")
	multip_sync.replication_config.add_property(shld_bar_path + ":size")
	multip_sync.replication_config.add_property(shld_bar_path + ":value")
	multip_sync.replication_config.add_property(shld_bar_path + ":max_value")	
	
func move():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		path = NavigationServer2D.map_get_path(map, self.position, get_global_mouse_position(), true)
		path.remove_at(0)
		
		avoid_fpath = true
		
	if path.size() > 0:
		self.direction = (path[0] - self.position).normalized()
		self.velocity = self.direction * speed_final
	else:
		self.velocity = Vector2.ZERO
	
	if (self.curr_state_action.state == State.StateAction.SLOWED):
		self.velocity *= 0.5
	elif (self.curr_state_action.state == State.StateAction.STUNNED or self.curr_state_action.state == State.StateAction.CONCENTRATE):
		self.velocity *= 0
	
	self.move_and_collide(self.velocity)
	if path.size() > 0 && self.position.distance_to(path[0]) < speed_final:
		path.remove_at(0)

	play_movement_animation(animation)
	#await get_tree().create_timer(0.05).timeout6
	
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

func new_round():
	super.new_round()
	var heros_number = ServiceScenes.players.map(func(player): return player.node).find(self)
	
	var corner = Vector2(
		(ServiceWindow.scene_size.x * 2) * (heros_number % 2),
		(ServiceWindow.scene_size.y * 2) * (floor(heros_number / 2))
	)
	
	self.position = Vector2(
		corner.x + POSITION_OFFSET_SPAWN if corner.x < ServiceWindow.scene_size.x else corner.x - POSITION_OFFSET_SPAWN,
		corner.y + POSITION_OFFSET_SPAWN if corner.y < ServiceWindow.scene_size.y else corner.y - POSITION_OFFSET_SPAWN,
	)
	
	ServiceScenes.camera.offset = self.position

func spells_placeholder_f(node: Node = self):
	var optionnal_placeholder = self.get_children().filter(func(child): return child is IPlaceholderSpells)
	return null if optionnal_placeholder.size() == 0 else optionnal_placeholder[0]
