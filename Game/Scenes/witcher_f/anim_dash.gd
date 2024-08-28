extends IAnimation

var champion
var rotate_speed = 25

# Called when the node enters the scene tree for the first time.
func after_ready():
	await super.after_ready()
	champion = ServiceScenes.championNode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority() && self.visible:
		self.position = champion.position
		self.rotate(deg_to_rad(rotate_speed))
		
func active():
	self.show()
	
	await get_tree().create_timer(spell_controller.cast_time).timeout
	self.hide()
