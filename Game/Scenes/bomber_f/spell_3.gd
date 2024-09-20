extends IDamagingSpell

var collision_shape

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 4.0
		damage_ratio = 0.08
		
		COLLISION_ON_SPECIFIC_ANIM = true
		state_action = State.StateAction.STUNNED
		state_duration = 0.75
		# ------------------------------------ #
		
		collision_shape = $CollisionShape2D

		await super._ready()
		
		animation.animation = "default"
		animation.animation_changed.connect(func():
			self.scale = self.scale / 15 if animation.animation == "default" else self.scale * 15
		)
		
func active():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 300)
	self.show()
	animation.play()
		
	await animation.animation_finished
	
	animation.animation = "damage"
	animation.play()
	await animation.animation_finished
	
	self.hide()
	animation.animation = "default"
