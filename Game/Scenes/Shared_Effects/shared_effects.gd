extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_multiplayer_authority(Server.get_first_player_connected_id())
	ServiceScenes.setSENode(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
