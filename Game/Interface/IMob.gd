extends ICharacter

class_name IMob

var service_health = preload("res://Game/Services/service_health.gd").new()

var collision_shape

var attack
var cd_attack = 1
var attack_timer: Timer

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		self.func_hitted.append(Callable(self, 'attack_back'))
		attack_timer = service_time.init_timer(self, cd_attack)
		
		await super.after_ready()
		animation.play("default")
		Servrpc.any(ServiceScenes, 'add_as_ennemy', [self])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		pass
	
func take_damage():
	if is_multiplayer_authority() && health_bar.value > 0:
		super.take_damage()
		Servrpc.send_to_multi_auth(self, 'send_damage_to_authority', [last_ennemy_hitting])
	
func send_damage_to_authority(heros_dealing_dmg):
	if (health_bar.value <= 0):
		die(heros_dealing_dmg)

func die(heros_dealing_dmg):
	self.func_hitted.remove_at(self.func_hitted.find(Callable(self, 'attack_back')))
	Servrpc.any(self, 'bonus', [heros_dealing_dmg])
	
	animation.play('die')
	animation.animation_finished.connect(func():
		for i in range(10):
			self.modulate.a -= 26
			await get_tree().create_timer(0).timeout
				
		self.hide()
	)
	
func attack_back():
	if (self.last_ennemy_hitting.position - self.global_position).x > 0:
		self.scale.x = 1
	else:
		self.scale.x = -1
		
	await multip_sync.synchronized
		
	animation.animation = 'attack'
	animation.play()
	
	if attack_timer.time_left == 0:
		attack.init_attack()
		animation.animation_finished.connect(func():
			animation.play('default')
		)
		attack_timer.start()
	
func bonus(heros_dealing_dmg):
	pass
	
	
