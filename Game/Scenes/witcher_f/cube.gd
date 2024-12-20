extends IPhysical

var collision_shape
var champion

var duration = 3
var duration_timer: Timer
var is_launching_laser: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		collision_shape = $CollisionShape2D
		
		champion = ServiceScenes.championNode
		duration_timer = service_time.init_timer(self, duration)
		
		self.visibility_changed.connect(func(): collision_shape.disabled = !self.visible)
		await super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active(base_position):
	self.position = base_position
	animation.play()
	
	self.modulate.a = 0
	self.show()
	for i in range(5):
		self.modulate.a += 0.2
		await get_tree().create_timer(0).timeout
	
	duration_timer.start()
	await duration_timer.timeout
	await resource_awaiter.await_resource_loaded(func(): return !is_launching_laser)
	
	self.hide()
	animation.stop()
