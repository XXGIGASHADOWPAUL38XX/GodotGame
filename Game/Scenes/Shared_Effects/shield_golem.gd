extends IAnimation

var champion_assigned
var modulate_bool: bool = false

func _ready():
	if is_multiplayer_authority():
		champion_assigned = ServiceScenes.get_player_from_property('id', get_multiplayer_authority()).node
		await super._ready()

func _process(delta):
	if is_multiplayer_authority() && self.visible:
		self.position = champion_assigned.position
		modulate_bool = ServiceSpell.modulate_obj(self, modulate_bool, 0.4, 0.6)
			
func active():
	self.show()
	champion_assigned.shield.set_shield(20, 30)
	
	#!!
	await get_tree().create_timer(5).timeout
	self.hide()


