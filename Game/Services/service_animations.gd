extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_animation(node, animation_name):
	Servrpc.any(self, 'set_animation_all', [node, animation_name])

func set_animation_all(node, animation_name):
	node.add_child(load("res://Game/Scenes/Animations/" + animation_name + ".tscn").duplicate().instantiate())
