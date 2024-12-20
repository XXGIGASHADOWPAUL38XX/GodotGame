extends IActive

var speed = 15
var cshape

func _ready():
	if is_multiplayer_authority():
		cshape = $CollisionShape2D
		
		await super._ready()

func _process(_delta):
	pass

func active(): #VISIBILITY HANDELED BY SPELLS_TANK_M_4
	self.show()
	animation.play()

	self.position = champion.position + ServiceSpell.set_in_front_mouse(
		champion, get_global_mouse_position(), 150)
	self.rotation = (self.position - champion.position).angle()
	
	await animation.animation_finished
	
	self.disappear()
	
func disappear():
	for i in range(10):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.01).timeout 
		
	self.hide()
	self.modulate.a = 1
	
