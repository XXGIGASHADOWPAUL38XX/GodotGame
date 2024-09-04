extends IDamagingSpell

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6
		damage_ratio = 0.1
		# ------------------------------------ #
		
		await super._ready()
		self.scale = Vector2(0.06, 0.06)

func active():
	self.position = champion.position
	self.show()
	
	animation.play()
	for i in range(15):
		self.scale *= 1.1
		self.modulate.a -= 0.5
		await get_tree().create_timer(0.01).timeout
	
	self.hide()
	self.modulate.a = 1
	self.scale = Vector2(0.06, 0.06)
	
	
