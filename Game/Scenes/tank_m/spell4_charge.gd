extends IActive

var speed = 15

var animation

func _ready():
	if is_multiplayer_authority():
		animation = $anim_zone
		
		super._ready()

func _process(_delta):
	pass

func active(): #VISIBILITY HANDELED BY SPELLS_TANK_M_4
	self.show()
	animation.play()

	self.position = champion.position + ServiceSpell.set_in_front_mouse(
		champion, get_global_mouse_position(), 200)
	self.rotation = (self.position - champion.position).angle()
	
	await get_tree().create_timer(1).timeout 
	
	for i in range(10):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.05).timeout 
		
	self.hide()
	self.modulate.a = 1
