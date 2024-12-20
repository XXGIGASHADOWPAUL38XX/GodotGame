extends HBoxContainer

var main_node

# Called when the node enters the scene tree for the first time.
func _ready():
	for button: Button in self.get_children():
		button.toggled.connect(on_click.bind(button))
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func on_click(toggled: bool, button: Button):
	var buttons_toggled = self.get_children().filter(func(button): return button.button_pressed).map(func(button):
		return button.name
	)
	
	if buttons_toggled.size() == 0:
		ServiceScenes.shop.items_container.get_children().map(func(item_container): item_container.show())
		return
		
	##!!
	#var filtered_items = item_class.get_list_by_category(buttons_toggled)
	
	#ServiceScenes.shop.items_container.get_children().map(func(item_container): 
		#item_container.visible = item_container.name.to_lower() in filtered_items
	#)

