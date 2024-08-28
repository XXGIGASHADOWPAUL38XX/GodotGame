extends IDamagingSpell

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super.after_ready()
		self.hide()
		
		animation = $Spells_warrior_anim_1_1 as AnimatedSprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active(angle):
	self.position = champion.position + (Vector2.RIGHT.rotated(angle).normalized() * 35)
	self.rotation = angle
	
	self.show()
	animation.play()
	
	await animation.animation_finished
	self.hide()
	
