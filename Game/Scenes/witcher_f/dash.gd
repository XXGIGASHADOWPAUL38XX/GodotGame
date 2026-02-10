extends IActive

func _ready():
	await super._ready()

func active_first():
	self.position = champion.position
	self.show()
	animation.play()

func active_back():
	champion.position = self.position
	self.hide()
