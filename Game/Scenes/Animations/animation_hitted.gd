extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.show()
	self.play("default")
	self.animation_finished.connect(animation_end)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func animation_end():
	get_parent().remove_child(self)
