extends IDamagingSpell

var rotate_speed = 5

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		
		animation = $Spells_warrior_anim_2

func _process(delta):
	if is_multiplayer_authority() && self.visible:
		self.rotate(deg_to_rad(rotate_speed))

func active():
	self.position = champion.position
	self.rotation = 0
	
	self.show()
	animation.play()

	await animation.animation_finished
	self.hide()
	
