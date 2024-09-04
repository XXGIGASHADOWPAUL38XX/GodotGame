extends ICollision

var player # INSTANCIE LORS DE LA DUPLICATION

func _ready():
	if is_multiplayer_authority():
		await super._ready()
		
		animation.animation_finished.connect(stop_spell)
		CONF_DETECT_WITH = ServiceScenes.alliesNode
			
func _process(_delta):
	if self.visible:
		self.global_position = player.position
			
func spell_purge_allies():
	Servrpc.send_to_id(player_hitted.get_multiplayer_authority(), ServiceStats, 
		'update_stats', [player_hitted, 'speed_bonus_ratio', 0.4]
	)
	player.remove_all_states('states_action')
	animation.play('default')
	
	self.modulate.a = 0.5
	self.global_position = player.position
	self.show()

	await get_tree().create_timer(1.5).timeout
	Servrpc.send_to_id(player_hitted.get_multiplayer_authority(), ServiceStats, 
		'update_stats', [player_hitted, 'speed_bonus_ratio', -0.4]
	)
	
func stop_spell():
	for i in range(10):
		self.global_position = player.position
		self.modulate.a -= 0.05
		await get_tree().create_timer(0.02).timeout

	self.hide()
	

