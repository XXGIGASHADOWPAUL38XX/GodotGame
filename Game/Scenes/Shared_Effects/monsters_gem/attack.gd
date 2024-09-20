extends IDamagingCollision

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 3
		damage_ratio = 0.0
		# ------------------------------------ #
		
		CONF_DETECT_WITH = ServiceScenes.allPlayersNode
		
		await super._ready()
		self.hide()
			
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
