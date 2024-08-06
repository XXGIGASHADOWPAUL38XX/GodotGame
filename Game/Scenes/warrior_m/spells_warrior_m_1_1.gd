extends IDamagingSpell

var animation: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		
		animation = $Spells_warrior_anim_1_1 as AnimatedSprite2D
		animation.animation_finished.connect(func(): 
			self.hide()
			champion.state_movement = State.StateMovement.NULL
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active(angle):
	champion.state_movement = State.StateMovement.IMMOBILE
	self.position = champion.position + (Vector2.RIGHT.rotated(angle).normalized() * 35)
	self.rotation = angle
	
	self.show()
	animation.play()
