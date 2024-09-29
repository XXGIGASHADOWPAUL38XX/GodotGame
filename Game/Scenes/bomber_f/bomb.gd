extends IDamagingSpell

var collision_shape
var rotate_speed = 5

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.2
		COLLISION_ON_SPECIFIC_ANIM = true
		# ------------------------------------ #
		
		collision_shape = $CollisionShape2D
		collision_shape.disabled
		
		await super._ready()
			
		animation.animation_changed.connect(func():
			self.scale = self.scale / 2 if animation.animation == "default" else self.scale * 2
		)
		
		self.area_entered.connect(func(area): 
			#!! faire un ticket github
			if area in (spells_placeholder.all_shoots + spells_placeholder.all_bombs) && area.visible:
				self.explode()
		)
		

		self.visibility_changed.connect(
			func(): self.call_deferred("set_collision_disabled", !self.visible)
		)
		
func set_collision_disabled(disabled: bool) -> void:
	self.get_node("CollisionShape2D").disabled = disabled

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
	animation.animation = "damage"
	animation.play()
	
	await animation.animation_finished
	self.hide()
	animation.animation = "default"
