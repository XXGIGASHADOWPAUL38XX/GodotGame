extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func post_dp_script(id, dp_number):
	self.position = Vector2(
		(id % 3) * ServiceWindow.scene_size.x,
		floor(id / 3) * ServiceWindow.scene_size.y
	)
