extends IActive

var base_scale

func _ready():
	if is_multiplayer_authority():
		base_scale = self.scale
		
		super._ready()

func _process(_delta):
	pass

func active(): 
	self.show()
	animation.play()

	self.position = champion.position
	
	for i in range(10):
		self.position = champion.position
		self.scale *= 1.1
		await get_tree().create_timer(0).timeout 
		
func end_spell():
	self.hide()
	self.scale = base_scale
	
func get_radius():
	return $CollisionShape2D.shape.radius
