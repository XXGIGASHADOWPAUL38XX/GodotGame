extends IDamagingSpell

var animation: AnimatedSprite2D
var collision_shape

var rotate_speed = 5

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.2
		# ------------------------------------ #
		
		collision_shape = $CollisionShape2D
		collision_shape.disabled
		
		animation = $anim_bomb as AnimatedSprite2D
		
		animation.animation_changed.connect(func():
			collision_shape.disabled = animation.animation == "default"
			self.scale = self.scale / 2 if animation.animation == "default" else self.scale * 2
		)
		
		self.area_entered.connect(func(area): 
			#!! faire un ticket github
			if area in (spells_placeholder.all_shoots + spells_placeholder.all_bombs) && area.visible:
				self.explode()
		)
		
		await super._ready()


func _process(delta):
	if is_multiplayer_authority():
		if self.visible && animation.animation == "default":
			self.rotate(deg_to_rad(rotate_speed))

func active(shoot_position):
	animation.animation = "default"
	self.position = shoot_position
	animation.play()
	self.show()
	
func explode():
	animation.animation = "explode"
	animation.play()
	
	await animation.animation_finished
	self.hide()
