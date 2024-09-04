extends ICollision

var speed = 20.0
var modulate_bool: bool = false
 
func _ready():
	#!!
	CONF_DETECT_WITH = ServiceScenes.alliesNode
	
	if is_multiplayer_authority():
		champion = ServiceScenes.championNode
		self.modulate.a = 0.5
		await super._ready()
			
		func_on_entity_entered.append(Callable(self, 'boost_zone_entered'))
		func_on_entity_exited.append(Callable(self, 'boost_zone_exited'))

func _process(_delta):
	if is_multiplayer_authority() && self.visible:
		modulate_bool = ServiceSpell.modulate_obj(self, modulate_bool, 0.2, 0.5)

func active():
	self.position = champion.position
	self.show()
	
	await get_tree().create_timer(5).timeout

	self.hide()

func boost_zone_entered():
	Servrpc.send_to_id(player_hitted.get_multiplayer_authority(), ServiceStats, 
		'update_stats', [player_hitted, 'speed_bonus_ratio', 0.3]
	)
	
func boost_zone_exited():
	Servrpc.send_to_id(player_hitted.get_multiplayer_authority(), ServiceStats, 
		'update_stats', [player_hitted, 'speed_bonus_ratio', 0.3]
	)

