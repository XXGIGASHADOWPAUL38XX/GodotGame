extends IAnimation

var champion

# Called when the node enters the scene tree for the first time.
func _ready():
	await super._ready()
	champion = ServiceScenes.championNode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority() && self.visible:
		self.position = champion.position

func active():
	champion.hide()
	self.show()
	self.play()
	await self.animation_finished
	
	self.hide()
	champion.show()
