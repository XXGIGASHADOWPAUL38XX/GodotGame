extends IDamagingSpell

var speed = 10
var animation

func _ready():	
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		
		animation = $anim_pulse
		func_on_entity_entered.append(Callable(self, 'push_ennemy'))

func active(mouse_position):
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, mouse_position, 30)
	var throw_direction = (mouse_position - champion.position).normalized()
	self.rotation = (self.position - champion.position).angle()
	animation.play()
	self.show()
	
	for i in range(15):
		self.position += throw_direction * speed
		await get_tree().create_timer(0).timeout
	
	animation.stop()
	self.hide()
	
	champion.remove_state(spell_controller.zone_b4pulse, 'states_action')
	spell_controller.zone_b4pulse.hide()

func push_ennemy():
	ServiceSpell.push_ennemy_global(self, player_hitted, 8)
