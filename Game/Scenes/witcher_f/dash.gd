extends IActive

func after_ready():
	if is_multiplayer_authority():
		await super.after_ready()
		animation = $anim_dash

func active_first():
	self.position = champion.position
	self.show()
	animation.play()

func active_back():
	champion.position = self.position
	self.hide()
