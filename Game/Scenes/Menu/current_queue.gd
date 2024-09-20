extends PanelContainer

var modulate_bool: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate_bool = ServiceSpell.modulate_obj(self, modulate_bool, 0.3, 0.6)

func add_to_queue_1v1():
	Servrpc.any(Server, "update_playerpeer_id", [Server.get_client_id(), "number_players_queue", Queue.QUEUE_KIND.MODE_1V1])
	self.show()
	
func add_to_queue_2v2():
	Servrpc.any(Server, "update_playerpeer_id", [Server.get_client_id(), "number_players_queue", Queue.QUEUE_KIND.MODE_2V2])
	self.show()
	
func remove_to_queue():
	Servrpc.any(Server, "update_playerpeer_id", [Server.get_client_id(), "number_players_queue", null])
	self.hide()
