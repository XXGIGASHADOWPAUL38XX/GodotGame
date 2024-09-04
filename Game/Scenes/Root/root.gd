extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.root_scene = self
	self.child_entered_tree.connect(func(scene_child): ServiceScenes.loading_async.check_if_loading(scene_child))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
