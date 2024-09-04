extends IDamagingSpell

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 4
		damage_ratio = 0.05
		# ------------------------------------ #
		
		await super._ready()
		
		func_on_entity_entered.append(Callable(self, 'push_ennemy'))

func active():
	self.position = champion.position + ServiceSpell.set_in_front(champion, 10)
	self.show()
	self.rotation = (get_global_mouse_position() - self.position).angle()
	var main_vector = (get_global_mouse_position() - champion.position).normalized() * 4

	animation.play()

	for i in range(25):
		champion.position = champion.position + main_vector
		self.position = champion.position + ServiceSpell.set_in_front(champion, 10)
		await get_tree().create_timer(0).timeout

	animation.stop()
	self.hide()
	
func push_ennemy():
	ServiceSpell.push_ennemy_global(self, player_hitted, 15)
