extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.frame = 0
	
	self.frame_changed.connect(func():
		if self.frame > 0:
			self.show()
		else:
			self.hide()
	)

func _process(delta):
	self.position = Vector2(
		ServiceScenes.championNode.position.x,
		ServiceScenes.championNode.position.y - 60
	)
