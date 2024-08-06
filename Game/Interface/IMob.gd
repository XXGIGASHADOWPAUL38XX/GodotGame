extends ICharacter

class_name IMob

var service_health = preload("res://Game/Services/service_health.gd").new()

var collision_shape

var attack
var cd_attack = 1
var attack_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		Servrpc.any(ServiceScenes, 'add_as_ennemy', [self])
		
		self.func_hitted.append(Callable(self, 'attack_back'))
		attack_timer = service_time.init_timer(self, cd_attack)
		animation.play("default")
		
		animation.animation_changed.connect(func(): 
			if animation.animation == 'attack' && attack_timer.time_left == 0:
				attack.init_attack()
				animation.animation_finished.connect(func():
					animation.play('default')
				)
				attack_timer.start()
		)
		
		await super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		ServiceHealth.setBar(self, health_bar)
	
func take_damage():
	if is_multiplayer_authority() && health_bar.value > 0:
		super.take_damage()
		Servrpc.send_to_multi_auth(self, 'send_damage_to_authority', [last_ennemy_hitting])
	
func send_damage_to_authority(heros_dealing_dmg):
	if (health_bar.value <= 0):
		die(heros_dealing_dmg)

func die(heros_dealing_dmg):
	self.func_hitted.remove_at(self.func_hitted.find(Callable(self, 'attack_back')))
	Servrpc.send_to_id(heros_dealing_dmg.get_multiplayer_authority(), self, 'bonus', [])
	
	animation.play('die')
	animation.animation_finished.connect(func():
		for i in range(10):
			animation.modulate.a -= 26
			await get_tree().create_timer(0).timeout
				
		self.hide()
	)
	
func attack_back():
	if (self.last_ennemy_hitting.position - self.position).x > 0:
		self.scale.x = 1
	else:
		self.scale.x = -1
		
	animation.animation = 'attack'
	
func bonus():
	pass
	
	
