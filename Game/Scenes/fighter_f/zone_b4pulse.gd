extends IActive

var cshape

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		immobile_while_active = true
		await super._ready()
		
		self.hide()
		
		cshape = $CollisionShape2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active(mouse_position):
	self.position = champion.position + ServiceSpell.set_in_front_mouse(
		champion, mouse_position, (cshape.shape.size.x / 2 * self.scale.x)
	)
	self.rotation = (self.position - champion.position).angle()
	
	animation.play()
	self.show()
	
	for i in range(10):
		champion.modulate = Color(1, 1 - (i * 0.05), 1 - (i * 0.1))
		await get_tree().create_timer(spell_controller.cast_time / 10).timeout
	
	champion.modulate = Color(1, 1, 1)
