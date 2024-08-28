extends IDamagingSpell

var collision_shape

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 4.0
		damage_ratio = 0.08
		# ------------------------------------ #
		
		collision_shape = $CollisionShape2D

		await super._ready()
		
		animation.animation_changed.connect(func():
			collision_shape.disabled = animation.animation == "default"
			self.scale = self.scale / 5 if animation.animation == "default" else self.scale * 5
		)
		
		
func active():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 300)
	self.show()
	animation.play()
		
	await animation.animation_finished
	self.hide()
