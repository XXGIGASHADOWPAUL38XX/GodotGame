extends IDamagingSpell

func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super.after_ready()
		self.hide()
		
		animation = $Spells_warrior_anim_2

func active():
	
	self.position = champion.position
	
	self.show()
	animation.play()

	await animation.animation_finished
	self.hide()
	
