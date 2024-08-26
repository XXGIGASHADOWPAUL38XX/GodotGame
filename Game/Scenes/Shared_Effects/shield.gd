extends IAnimation

var champion_assigned
var modulate_bool: bool = false
var duration = 2

func _ready():
	if is_multiplayer_authority():
		champion_assigned = ServiceScenes.get_player_from_property('id', get_multiplayer_authority()).node
		await super._ready()

func _process(delta):
	if is_multiplayer_authority() && self.visible:
		self.position = champion_assigned.position
		modulate_bool = await ServiceSpell.modulate_obj(self, modulate_bool, 0.25, 0.5)
			
func active():
	self.show()
	champion_assigned.add_state(self, 'states_damage', State.StateDamage.IMMUNE)
	champion_assigned.add_state(self, 'states_movement', State.StateMovement.IMMOBILE)
	
	await get_tree().create_timer(duration).timeout
	
	champion_assigned.remove_state(self, 'states_damage')
	champion_assigned.remove_state(self, 'states_movement')
	self.hide()

