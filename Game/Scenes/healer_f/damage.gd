extends IDamagingSpell

var collision_shape

func _ready():
	if is_multiplayer_authority():
		COLLISION_ON_SPECIFIC_ANIM = true
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		collision_shape = $CollisionShape2D
		
		await super._ready()
		
		animation.animation = "default"
		animation.animation_changed.connect(func():
			self.scale = self.scale * 2.5 if animation.animation == "damage" else self.scale / 2.5
		)

func active():
	animation.animation = "default"
	
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 350)
	animation.play()
	self.show()
	
	await animation.animation_finished
	
	explode()
	
func explode():
	animation.animation = "damage"
	animation.play()
	
	await animation.animation_finished
	self.hide()
