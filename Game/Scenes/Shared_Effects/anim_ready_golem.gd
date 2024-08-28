extends IAnimation

var champion_assigned

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		self.modulate.a = 0.75
		champion_assigned = ServiceScenes.get_player_from_property('id', get_multiplayer_authority()).node
		await super.after_ready()
		
		for i in range(15):
			self.scale *= 1.075
			self.modulate.a -= 0.05
			await get_tree().create_timer(0).timeout
		
		self.hide()

func _process(delta):
	if is_multiplayer_authority() && self.visible:
		self.position = champion_assigned.position
