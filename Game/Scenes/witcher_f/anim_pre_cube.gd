extends IAnimation


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func active(base_position):
	self.position = base_position
	self.show()
	self.play()
	
	await self.animation_finished
	self.hide()
