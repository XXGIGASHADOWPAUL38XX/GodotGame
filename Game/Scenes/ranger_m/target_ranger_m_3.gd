extends IActive

var speed = 20.0
var animation: AnimatedSprite2D

var cd_target = 10.0
var target_timer: Timer = Timer.new()

var modulate_bool: bool = false
var key_ennemy_marked

func _ready():
	if is_multiplayer_authority():
		self.hide()
		animation = $target_anim as AnimatedSprite2D
		
		await super._ready()
		
		for damaging_spells in spells_placeholder.all_actives.filter(func(s): 
			return !s.name.begins_with('target') && s is ICollision):
				damaging_spells.func_on_entity_entered.append(Callable(self, 'marked').bind(damaging_spells)
		)
		

func _process(delta):
	if is_multiplayer_authority() && key_ennemy_marked != null:
		self.position = key_ennemy_marked.position
		
		if target_timer.time_left == 0:
			self.hide()
		elif target_timer.time_left < 2.5:
			modulate_bool = await ServiceSpell.modulate_obj(self, modulate_bool)
		else:
			self.show()

#		if Input.is_key_pressed(KEY_E) && coltdown_spell3.time_left == 0 && animation.frame > 0:
#			coltdown_spell3.start()
#			active()
			
		self.rotate(delta)

func marked(spell):
	if spell.player_hitted == key_ennemy_marked:
		Servrpc.send_to_multi_auth(self, 'send_to_local', [spell.player_hitted])

func send_to_local(player_hitted):
	animation.frame += 1
	target_timer = service_time.init_timer(self, cd_target)
	target_timer.start()



