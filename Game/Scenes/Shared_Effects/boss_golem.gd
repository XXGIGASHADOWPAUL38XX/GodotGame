extends "res://Game/Interface/IHeros.gd"

var service_health = preload("res://Game/Services/service_health.gd").new()
var health_bar
var animation
var collision_shape

var attack_golem
var attack_timer: Timer

var heros_spells

# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.allEnnemiesNode.append(self) 
	self.add_func_hitted(Callable(self, 'attack_back').bind(self.ennemy_h))
	
	attack_golem = get_node('attack_golem')
	health_bar = $health_bar
	
	self.position = Vector2(get_window().size.x, get_window().size.y)
	heros_spells = ServiceScenes.getChampionSpells()
	
	if is_multiplayer_authority():
		attack_timer = service_time.init_timer(self, 1)
		animation = $boss_golem_anim
		collision_shape = $CollisionShape2D as CollisionShape2D
		animation.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		ServiceHealth.setBar(self, health_bar)
		
		if animation.animation == 'attack':
			if attack_timer.time_left == 0:
				attack_golem.init_attack()
				animation.play('attack')
				animation.animation_finished.connect(func():
					animation.play('default')
				)
				attack_timer.start()
				
func take_damage(spell, sp):
	Servrpc.send_to_multi_auth(self, 'send_damage_to_authority', [sp.damage, ServiceScenes.champion.name])
	
func send_damage_to_authority(damage, heros_dealing_dmg):
	health_bar.value -= damage
	
	if (health_bar.value <= 0):
		die_animation(heros_dealing_dmg)
	else:
		attack_back(heros_dealing_dmg)
	
	for i in range(2):
		animation.modulate = Color.RED
		await get_tree().create_timer(0.15).timeout
		animation.modulate = Color.WHITE
		await get_tree().create_timer(0.15).timeout

func die_animation(heros_dealing_dmg):
	Servrpc.send_to_champion(self, heros_dealing_dmg, 'bonus', [])
	ServiceAnnounce.set_announce(
		heros_dealing_dmg + 'has defeated the crystal boss',
		'res://Game/Ressources/Heros/icons/' + heros_dealing_dmg + '.png',
		'res://Game/Ressources/Main_Effects/Foozle_2DE0001_Pixel_Magic_Effects/Mecha-stone Golem 0.1/logo.png'
	)
	
	for i in range(6):
		self.position.y += 5
		await get_tree().create_timer(0.03).timeout
	
	animation.play('die')
	self.position.y -= 40
	await get_tree().create_timer(0.5).timeout
	
	for i in range(10):
		animation.modulate.a -= 26
		await get_tree().create_timer(0).timeout
			
	self.hide()
	
func attack_back(heros_dealing_dmg):
	var heros_dealing_dmg_node = [ServiceScenes.get_players()].filter(
		func (heros):
			return heros.name == heros_dealing_dmg
	)[0]
	
	if (heros_dealing_dmg_node.position - self.position).x < 0:
		self.scale.x = -1
	else:
		self.scale.x = 1
		
	animation.animation = 'attack'	
	
func bonus():
	ServiceScenes.championNode.get_node('shield').set_shield(20, 10)
	
	
