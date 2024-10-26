extends IActive

func _ready():
	if is_multiplayer_authority():
		await super._ready()
		animation = $anim_dash

func active_first():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 140)
	champion.position = self.position
	estomp()
	
	animation.play()

func active_back():
	self.position = champion.position
	
	animation.play()
	await estomp()
	
func estomp():
	self.modulate.a = 1
	self.show()
	
	for i in range(10):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.03).timeout
		
	self.hide()
