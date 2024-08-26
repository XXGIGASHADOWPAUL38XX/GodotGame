extends IActive

var animation: AnimatedSprite2D
var cshape

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		await super._ready()
		self.hide()
		
		animation = $anim_zone as AnimatedSprite2D
		cshape = $CollisionShape2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active(mouse_position):
	champion.add_state(self, 'states_movement', State.StateMovement.IMMOBILE)
	
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, mouse_position, 30 + (cshape.shape.size.x / 2 * 0.1))
	self.rotation = (self.position - champion.position).angle()
	
	animation.play()
	self.show()
	
	await get_tree().create_timer(0.5).timeout
	
	spell_controller.pulse.active(mouse_position)
	
