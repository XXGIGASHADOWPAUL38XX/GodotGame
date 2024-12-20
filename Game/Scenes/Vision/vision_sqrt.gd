extends IVision

var vision_duration = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		# ----------------- IVision -----------------  #
		vision_area = $vision_area
		# ----------------- IVision -----------------  #
		await super._ready()
		
		self.visibility_changed.connect(func():
			if self.visible: vision_area.animation.play()
			else: vision_area.animation.stop()
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active():
	self.position = get_global_mouse_position()
	self.show()
	for i in range(10):
		self.energy += 0.1
		await get_tree().create_timer(0).timeout
		
	await get_tree().create_timer(vision_duration).timeout
	
	for i in range(10):
		self.energy -= 0.1
		await get_tree().create_timer(0).timeout
		
	self.hide()
	
