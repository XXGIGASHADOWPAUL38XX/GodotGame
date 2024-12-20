extends IAnimation

var champion

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		champion = ServiceScenes.championNode
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		pass
		
func active():
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 20)
	self.show()
	self.play()
	
	await self.animation_finished
	self.hide()
