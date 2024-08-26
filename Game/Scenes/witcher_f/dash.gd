extends IActive

var animation

func _ready():
	if is_multiplayer_authority():
		await super._ready()
		animation = $anim_dash

func active_first():
	self.position = champion.position
	self.show()
	animation.play()

func active_back():
	champion.position = self.position
	self.hide()
