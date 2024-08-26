extends IDamagingSpell

var animation: AnimatedSprite2D
var collision_shape

func _ready():
	if is_multiplayer_authority():
		DISABLE_BASE_BEHAVIOR_COLLISION = true
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		collision_shape = $CollisionShape2D
		
		animation = $anim_damage as AnimatedSprite2D
		
		self.visibility_changed.connect(func(): 
			if !self.visible:
				collision_shape.disabled = true
		)
		
		animation.frame_changed.connect(func():
			collision_shape.disabled = animation.frame < 3
			if animation.animation == "explode":
				self.modulate.a == min(1, 1.4 - (animation.frame / 10))
		)
		
		await super._ready()

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
