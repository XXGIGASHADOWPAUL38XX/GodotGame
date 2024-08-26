extends IDamagingSpell

var animation

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 2.5
		damage_ratio = 0.05
		# ------------------------------------ #
		
		await super._ready()
		
		animation = $anim_special_pulse
		func_on_entity_entered.append(Callable(self, 'push_ennemy'))

func active():
	self.position = ServiceScenes.championNode.position
	self.scale = Vector2(0.075, 0.075)
	self.modulate.a = 0.5
	self.show()
	
	for i in range(25):
		self.scale = self.scale * 1.06
		self.modulate.a -= 0.02
		await get_tree().create_timer(0.01).timeout
		
	self.hide()

func push_ennemy():
	ServiceSpell.push_ennemy_global(self, player_hitted, 15, true)
