extends IActive

func after_ready():
	if is_multiplayer_authority():
		await super.after_ready()
		animation = $anim_dash

func active_first():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 140)
	self.show()
	champion.position = self.position
	
	animation.play()

func active_back():
	self.hide()
