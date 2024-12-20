extends IDamagingCollision

func _ready():
	# DEFINITION VARIABLES IDAMAGING SPELL #
	damage_base = 10.0
	CONF_DETECT_WITH = [ServiceScenes.entities.alliesNode, ServiceScenes.entities.ennemiesNode]
	# ------------------------------------ #
	
	await super._ready()
