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
				
		animation.frame_changed.connect(func():
			if animation.animation == "explode":
				self.modulate.a == min(1, 1.2 - (animation.frame / 10))
		)

func active():
	animation.animation = "default"
	
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 350)
	animation.play()
	self.show()
	
	##!! remplacer par deuxième ligne quand animation faite
	await get_tree().create_timer(0.5).timeout
	#await animation.animation_finished
	
	explode()
	
func explode():
	animation.animation = "explode"
	animation.play()
	
	await animation.animation_finished
	self.hide()
