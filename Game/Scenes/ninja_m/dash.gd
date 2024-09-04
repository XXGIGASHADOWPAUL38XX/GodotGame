extends IDamagingSpell

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 5
		damage_ratio = 0.08
		# ------------------------------------ #
		
		await super._ready()

func active():
	self.show()
	var main_vector = (get_global_mouse_position() - champion.position).normalized() * 8
	self.rotation = main_vector.angle()

	animation.play()

	for i in range(10):
		champion.position = champion.position + main_vector
		self.position = champion.position + ServiceSpell.set_in_front(champion, 15)
		await get_tree().create_timer(0).timeout

	animation.stop()
	self.hide()
