extends IDamagingCollision

func _ready():
	if is_multiplayer_authority():
		CONF_DETECT_WITH = [ServiceScenes.entities.alliesNode, ServiceScenes.entities.ennemiesNode]
		
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.0
		# ------------------------------------ #
		
		await super._ready()
		
		
func _process(_delta):
	pass
	
func init_attack():
	await get_tree().create_timer(0.25).timeout
	self.show()
	animation.play()
	
	await animation.animation_finished
	self.hide()

