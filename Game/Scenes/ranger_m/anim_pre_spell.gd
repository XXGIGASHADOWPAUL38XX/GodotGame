extends IAnimation

# Called when the node enters the scene tree for the first time.
func _ready():
	await super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active():
	if is_multiplayer_authority():
		self.position = get_global_mouse_position()
		self.play("default")
		self.show()
		
		await self.animation_finished
		self.hide()
		
