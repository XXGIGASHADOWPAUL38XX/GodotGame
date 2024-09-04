extends IActive

var modulate_bool = false

var healing_base

func _ready():
	if is_multiplayer_authority():
			
		await super._ready()
		
func active():
	Servrpc.any(self, 'hide_champion', [])
	self.position = champion.position
	
	animation.play()
	self.show()
	await animation.animation_finished
	
	self.hide()
	await get_tree().create_timer(0.5).timeout
	Servrpc.any(self, 'show_champion_back', [])
	
func hide_champion():
	champion.multip_sync.replication_config.remove_property(champion.name + ':visible')
	if is_multiplayer_authority():
		champion.modulate.a = 0.5
	else:
		champion.hide()
		
func show_champion_back():
	champion.multip_sync.replication_config.add_property(champion.name + ':visible')
	if is_multiplayer_authority():
		champion.modulate.a = 1

