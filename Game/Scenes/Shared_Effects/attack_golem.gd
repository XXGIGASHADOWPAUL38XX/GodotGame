extends CharacterBody2D

var animation

func _ready():
	if is_multiplayer_authority():
		self.hide()
		animation = $anim_attack_golem
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

