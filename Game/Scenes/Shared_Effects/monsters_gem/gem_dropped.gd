extends ICollision

var speed = 10

# Called when the node enters the scene tree for the first time.
func after_ready():
	await super.after_ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func dropped(monster_gem, heros):
	self.position = monster_gem.position
	
	self.show()
	while not ServiceSpell.is_close_to(self, heros, speed):
		self.position += (heros.position - self.global_position).normalized() * speed
		await get_tree().create_timer(0.01).timeout
		
	self.hide()

	
	
