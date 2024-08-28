extends IDamagingSpell

func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 1.0
		damage_ratio = 0.015
		# ------------------------------------ #
		
		await super.after_ready()
		
func _process(_delta):
	if is_multiplayer_authority():
		if self.visible:
			self.position = champion.position
		
func active():
	self.show()
	animation.play()

func stop_spell():
	self.hide()
	animation.stop()

