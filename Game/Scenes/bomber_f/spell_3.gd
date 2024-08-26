extends IDamagingSpell

var animation: AnimatedSprite2D
var collision_shape

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 4.0
		damage_ratio = 0.08
		# ------------------------------------ #
		
		animation = $anim_stunning_bomb
		collision_shape = $CollisionShape2D

		animation.animation_changed.connect(func():
			collision_shape.disabled = animation.animation == "default"
			self.scale = self.scale / 5 if animation.animation == "default" else self.scale * 5
		)
		
		await super._ready()
		
func active():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 300)
	self.show()
	animation.play()
		
	await animation.animation_finished
	self.hide()
