extends "res://Game/Interface/ISpell.gd"

const MARGIN_SPAWN_X = 300
const MARGIN_SPAWN_Y = 200

var timer_spawn = Timer.new()
var timer_explode = Timer.new()
var animation

var base_position_spawn
var direction_vector
var modulate_bool: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	CONF_DETECT_WITH = ServiceScenes.allPlayersNode
	super._ready()
	animation = $blue_spirit_anim
	if is_multiplayer_authority():
		var direction = randi_range(0, 1)
		direction_vector = Vector2(direction, (direction + 1) % 2)
		
		timer_spawn = service_time.init_timer(self, 2)
		timer_spawn.start()
		timer_spawn.timeout.connect(spawn)
		
		animation.animation_changed.connect(func(): self.get_node("CollisionShape2D"
		).disabled = animation.animation != 'special')
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		if animation.animation == 'special':
			modulate_bool = await ServiceSpell.modulate_obj(self, modulate_bool)
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
		randf_range(MARGIN_SPAWN_X, get_window().size.x - MARGIN_SPAWN_X), 
		randf_range(MARGIN_SPAWN_Y, get_window().size.y - MARGIN_SPAWN_Y))
	
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
	
func entity_entered(player):
	Servrpc.any(ServiceStats, 'update_stats_local', [player, 'speed_bonus_ratio', player.speed_bonus_ratio + 0.3])
	
func entity_exited(player):
	Servrpc.any(ServiceStats, 'update_stats_local', [player, 'speed_bonus_ratio', player.speed_bonus_ratio - 0.3])
