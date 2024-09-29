extends IDamagingSpell

var speed = 3


func _ready():	
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 3.0
		damage_ratio = 0.075
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		
		animation = $Spells_warrior_anim_3

func active():
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 30)
	var throw_direction = (get_global_mouse_position() - champion.position).normalized()
	self.rotation = (get_global_mouse_position() - self.position).angle()
	
	champion.add_state(self, 'states_damage', State.StateDamage.IMMUNE)
	champion.hide()
	self.show()
	
	animation.play()

	for i in range(30):
		self.position += throw_direction * speed
		await get_tree().create_timer(0).timeout
	
	animation.stop()
	champion.position = self.position + ServiceSpell.set_in_front(self, 15)
	self.hide()
	champion.show()
	
	champion.remove_state(self, 'states_damage')
