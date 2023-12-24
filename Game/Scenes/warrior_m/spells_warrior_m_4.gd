extends "res://Game/Interface/ISpell.gd"

var speed = 20.0
var champion
var throw_direction = Vector2.RIGHT
var cd_spell4 = 14.0
var spell4: AnimatedSprite2D
var coltdown_spell4: Timer
var HUD

func _ready():
	CONF_DETECT_WITH = ServiceScenes.alliesNode
	if is_multiplayer_authority():
		champion = ServiceScenes.championNode
		self.modulate.a = 0
		super._ready()
		spell4 = $Spells_warrior_anim_4
		coltdown_spell4 = service_time.init_timer(self, cd_spell4)
		
		func_on_entity_entered.append(Callable(self, 'boost_zone_entered'))
		func_on_entity_exited.append(Callable(self, 'boost_zone_exited'))

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_SPACE) && coltdown_spell4.time_left == 0:
			coltdown_spell4.start()
			spell4_boost()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell4, 3)

func spell4_boost():
	self.position = champion.position
	self.show()
	
	for i in range(10):
		self.modulate.a += 0.03
		await get_tree().create_timer(0.01).timeout
		
	await get_tree().create_timer(5).timeout
	
	for i in range(10):
		self.modulate.a -= 0.03
		await get_tree().create_timer(0.01).timeout

	self.hide()

func boost_zone_entered():
	Servrpc.any(ServiceStats, 'update_stats_local', [player_hitted, 'speed_bonus_ratio', player_hitted.speed_bonus_ratio + 0.3])
	
func boost_zone_exited():
	Servrpc.any(ServiceStats, 'update_stats_local', [player_hitted, 'speed_bonus_ratio', player_hitted.speed_bonus_ratio - 0.3])
	

