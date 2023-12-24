extends Area2D

var champion

func _ready():
	if is_multiplayer_authority():
		champion = ServiceScenes.championNode
		$AnimatedSprite2D.play("passive")

func _process(delta):
	if is_multiplayer_authority():
		rotate(delta)
		passive_true()

func passive_true():
	if get_meta('passive') == true:
		self.show()
		self.position = champion.position
	else:
		self.hide()
	
