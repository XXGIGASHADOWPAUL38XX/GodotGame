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
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, mouse_position, 30 + (cshape.shape.size.x / 2 * 0.1))
	self.rotation = (self.position - champion.position).angle()
	
	animation.play()
	self.show()
	
	await get_tree().create_timer(0.5).timeout
	
	spell_controller.pulse.can_active(mouse_position)
	
