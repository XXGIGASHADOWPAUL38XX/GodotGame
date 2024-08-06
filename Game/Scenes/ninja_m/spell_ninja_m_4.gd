extends Node2D

var shuriken 
var shadow

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		shuriken = $shuriken_m_4
		shadow = $shadow_m_4

func active():
	shadow.hide()
	await shuriken.active()
	shadow.active(shuriken)

func post_dp_script(id):
	shuriken.angle = id * 120
