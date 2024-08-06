extends ICollision

var speed = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func dropped(heros):
	self.show()
	while not ServiceSpell.isCloseTo(self, heros, 15):
		self.global_position += (heros.position - self.global_position).normalized() * speed
		await get_tree().create_timer(0.01).timeout
		
	self.hide()

	
	
