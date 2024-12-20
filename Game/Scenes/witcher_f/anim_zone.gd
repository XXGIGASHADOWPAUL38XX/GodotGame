extends IAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active(spell_position):
	self.position = spell_position
	self.play()
	self.show()
	
func desactive():
	self.hide()
	self.stop()
