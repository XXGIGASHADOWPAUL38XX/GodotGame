extends IPlaceholderSpells

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_multiplayer_authority(Server.get_first_player_connected_id())
	await super._ready()
