extends ICollision

const MARGIN_SPAWN_X = 300
const MARGIN_SPAWN_Y = 200

var timer_spawn = Timer.new()
var timer_explode = Timer.new()

var base_position_spawn
var direction_vector
var modulate_bool: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		CONF_DETECT_WITH = [ServiceScenes.entities.alliesNode, ServiceScenes.entities.ennemiesNode]
		var direction = randi_range(0, 1)
		direction_vector = Vector2(direction, (direction + 1) % 2)
		
		timer_spawn = service_time.init_timer(self, 2)
		timer_spawn.start()
		timer_spawn.timeout.connect(spawn)
		
		await super._ready()
		
		animation.animation_changed.connect(func(): self.get_node("CollisionShape2D"
		).disabled = animation.animation != 'special')
		
		func_on_entity_entered.append(Callable(self, 'boost_speed'))
		func_on_entity_exited.append(Callable(self, 'end_boost_speed'))
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		if animation.animation == 'special':
			modulate_bool = ServiceSpell.modulate_obj(self, modulate_bool)
			self.rotate(delta)
		else:
			self.position += direction_vector
			
			if self.position.distance_to(base_position_spawn) > 100:
				direction_vector *= -1

func spawn():
	animation.animation = 'default'
	animation.play()
	self.modulate.a = 1
	self.rotation = 0.0
	
	base_position_spawn = Vector2(
		randf_range(MARGIN_SPAWN_X, (ServiceWindow.scene_size.x * 2) - MARGIN_SPAWN_X), 
		randf_range(MARGIN_SPAWN_Y, (ServiceWindow.scene_size.y * 2) - MARGIN_SPAWN_Y)
	)
	
	self.position = base_position_spawn
	self.show()
		
	timer_explode = service_time.init_timer(self, 5)
	timer_explode.start()
	timer_explode.timeout.connect(activate)
	
func die_animation():
	for i in range(10):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.1).timeout
		
	self.hide()
	
	timer_spawn.start()

func activate():
	for i in range (4):
		self.modulate.a = 0.5
		await get_tree().create_timer(0.15).timeout
		self.modulate.a = 1
		await get_tree().create_timer(0.15).timeout
		
	animation.animation = 'special'
	direction_vector = Vector2.ZERO
	
	await get_tree().create_timer(5).timeout
	await die_animation()
	
func boost_speed():
	Servrpc.send_to_id(player_hitted.get_multiplayer_authority(), ServiceStats, 
		'update_stats', [player_hitted, 'speed_bonus_ratio', 0.6]
	)
	
func end_boost_speed():
	Servrpc.send_to_id(player_hitted.get_multiplayer_authority(), ServiceStats, 
		'update_stats', [player_hitted, 'speed_bonus_ratio', -0.6]
	)
