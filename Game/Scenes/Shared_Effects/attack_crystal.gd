extends "res://Game/Interface/IDamagingSpell.gd"

var animation

func _ready():
	if is_multiplayer_authority():
		CONF_DETECT_WITH = ServiceScenes.allPlayersNode
		super._ready()
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

