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
		
		animation = $Spells_warrior_anim_1_3 as AnimatedSprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active(angle):
		
	self.position = champion.position + (Vector2.RIGHT.rotated(angle).normalized() * 25)
	self.rotation = angle
	
	self.show()
	animation.play()

	for i in range(20):
		self.position += Vector2.RIGHT.rotated(angle).normalized() * 5
		await get_tree().create_timer(0).timeout

	self.hide()
	
