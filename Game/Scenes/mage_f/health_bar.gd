extends ProgressBar

const decalage = 35

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if is_multiplayer_authority():
		self.position = Vector2(
			ServiceScenes.championNode.position.x + (self.size.x / -2), 
			ServiceScenes.championNode.position.y + (decalage * -1)
		)
