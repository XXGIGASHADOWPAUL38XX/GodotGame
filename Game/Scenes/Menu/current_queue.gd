extends PanelContainer

var modulate_bool: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate_bool = ServiceSpell.modulate_obj(self, modulate_bool, 0.3, 0.6)

func add_to_queue():
	Server.createClient()
	self.show()
	
func remove_to_queue():
	Server.removeClient()
	self.hide()
