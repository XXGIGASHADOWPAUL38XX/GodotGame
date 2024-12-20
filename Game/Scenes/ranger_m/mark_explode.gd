extends IDamagingSpell

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.2
		# ------------------------------------ #
		
		await super._ready()
		self.hide()

func active(target_position):
	if is_multiplayer_authority():
		self.position = target_position + ServiceSpell.set_random_pos(15)
		self.scale = Vector2(0.05, 0.05)
		self.modulate.a = 1
		self.show()
		self.animation.play()
		
		for i in range(8):
			self.scale = self.scale * 1.03
			self.modulate.a -= 0.01
			await get_tree().create_timer(0).timeout
			
		self.hide()

