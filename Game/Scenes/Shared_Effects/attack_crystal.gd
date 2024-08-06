extends IDamagingCollision

var animation

func _ready():
	if is_multiplayer_authority():
		CONF_DETECT_WITH = ServiceScenes.allPlayersNode
		
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.0
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		animation = $anim_attack_crystal
		
		animation.animation_finished.connect(
			func():
				self.hide()
		)
	
func _process(_delta):
	pass
	
func init_attack():
	await get_tree().create_timer(0.25).timeout
	self.show()
	animation.play("default")

