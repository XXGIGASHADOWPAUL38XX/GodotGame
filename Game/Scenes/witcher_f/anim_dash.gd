extends IAnimation

var champion
var rotate_speed = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	await super._ready()
	champion = ServiceScenes.championNode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority() && self.visible:
		self.position = champion.position
		self.rotate(deg_to_rad(rotate_speed))
		
func active():
	champion.add_state(self, 'states_action', State.StateAction.IMMOBILE)
	self.show()
	
	await get_tree().create_timer(0.25).timeout
	self.hide()
	
	champion.remove_state(self, 'states_action')
