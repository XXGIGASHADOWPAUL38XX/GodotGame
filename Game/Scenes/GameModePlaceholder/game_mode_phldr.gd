extends Control

var current_plhdr = null

var offset = 500
var frames = 10
const MARGIN_RIGHT_OFFSET = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	current_plhdr = self.get_children().filter(func(child): return child.visible)[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_placeholder(type):
	var new_plhdr = self.get_node(type as NodePath)
	if new_plhdr == current_plhdr:
		return
		
	display_placeholder(new_plhdr)
	
	if current_plhdr != null:
		hide_placeholder(current_plhdr)
	
	current_plhdr = new_plhdr
	
func display_placeholder(plhdr):
	var margin = plhdr.get_node("margin")
	margin.add_theme_constant_override('margin_left', 0)
	margin.add_theme_constant_override('margin_right', (offset * -1) - MARGIN_RIGHT_OFFSET)
	
	plhdr.modulate.a = 0.5
	plhdr.show()
	
	for i in range(frames):
		plhdr.modulate.a += 0.05
		margin.add_theme_constant_override('margin_left', offset - ((offset / frames) * (i + 1)))
		margin.add_theme_constant_override('margin_right', - offset + ((offset / frames) * (i + 1)) - MARGIN_RIGHT_OFFSET)
		
		await get_tree().create_timer(0.01).timeout
	
func hide_placeholder(plhdr):
	var margin = plhdr.get_node("margin")
	
	for i in range(frames):
		plhdr.modulate.a -= 0.05
		margin.add_theme_constant_override('margin_left', (offset / frames) * (i + 1))
		margin.add_theme_constant_override('margin_rigth', (offset / frames) * -(i + 1) - MARGIN_RIGHT_OFFSET)
		await get_tree().create_timer(0.01).timeout
		
	plhdr.hide()
