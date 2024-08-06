extends IDamagingSpell

var animation: AnimatedSprite2D

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 1.0
		damage_ratio = 0.015
		# ------------------------------------ #
		
		await super._ready()
		animation = $anim_tank_m_2
	
func _process(_delta):
	if is_multiplayer_authority():
		if self.visible:
			self.position = champion.position
		
func active():
	self.show()
	animation.play()

func stop_spell():
	self.hide()
	animation.stop()

