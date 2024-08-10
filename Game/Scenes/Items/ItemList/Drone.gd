extends IItems

# Called when the node enters the scene tree for the first time.
func _ready():
	self.item_actif = $GridContainer/MarginContainer/Panel5/drone_gem
	await super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
