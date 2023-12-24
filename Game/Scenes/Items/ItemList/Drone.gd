extends "res://Game/Interface/IItems.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.item_actif = $GridContainer/MarginContainer/Panel5/drone_gem
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
