extends Node2D

var sphere
var missile

# Called when the node enters the scene tree for the first time.
func _ready():
	sphere = $sphere
	missile = $missile

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active():
	sphere.active()

func post_dp_script(id, dp_number):
	sphere.current_angle = (id - 1) * PI
