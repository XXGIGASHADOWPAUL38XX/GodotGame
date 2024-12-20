extends IAnimation

var champion

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		champion = ServiceScenes.championNode
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func leap():
	self.position = champion.position
	self.play()
	self.show()
	
	champion.leap()
	
	await self.animation_finished
	self.hide()

func fall_back():
	self.position = champion.position
	champion.fall_back()
	self.play()
	self.show()
	
	await self.animation_finished
	self.hide()
