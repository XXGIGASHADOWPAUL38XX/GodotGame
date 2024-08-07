extends IAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active():
	self.position = ServiceScenes.championNode.position
	self.play()
	self.show()
	
	await self.animation_finished
	self.hide()
