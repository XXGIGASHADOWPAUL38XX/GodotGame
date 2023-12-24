extends HBoxContainer

var main_node

# Called when the node enters the scene tree for the first time.
func _ready():
	main_node = get_parent().get_parent().get_parent()
	for button in self.get_children():
		button.pressed.connect(on_click.bind(button))
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func on_click(button):
	main_node.filter(button.text)

