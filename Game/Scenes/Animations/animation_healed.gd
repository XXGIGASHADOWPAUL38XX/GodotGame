extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0.5
	self.play("default")
	self.show()
	self.animation_finished.connect(animation_end)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func animation_end():
	get_parent().remove_child(self)
