extends IAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		await super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active(entity):
	self.position = entity.position
	self.play()
	self.scale = Vector2(0.08, 0.08)
	self.modulate.a = 0.4
	self.show()
	
	for i in range(12):
		self.scale += Vector2(0.02, 0.02)
		await get_tree().create_timer(0).timeout
		self.modulate.a += 0.05
		
	self.stop()
	
