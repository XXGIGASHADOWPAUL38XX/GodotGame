extends IPhysical

var collision_shape
var champion

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		self.modulate.a = 0
		champion = ServiceScenes.championNode
			
		collision_shape = $CollisionShape2D
		self.visibility_changed.connect(func(): collision_shape.disabled = !self.visible)
		await super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active():
	self.position = champion.position
	self.show()
	spells_placeholder.controller_laser.launch_lasers(self)
	
	await get_tree().create_timer(0.1).timeout
	
	self.hide()
