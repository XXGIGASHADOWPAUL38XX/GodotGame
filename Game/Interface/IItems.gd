extends Control

class_name IItems

var items_container = []
var item_actif: TextureButton
var item_class = preload("res://Game/Classes/Item/item.gd").new()

var resource_awaiter = ResourceAwaiter.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	items_container = get_all_textureRect(self)
	
	#!!
	item_actif.mouse_entered.connect(displayStats.bind(item_class.get(item_actif.name)))
	items_container.map(func(orb): orb.mouse_entered.connect(displayStats.bind(item_class.get(orb.name))))
	disable_all_items()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_all_textureRect(node: Control):
	var items = []
	if node is TextureRect:
		items.append(node)

	for child in node.get_children():
		var child_items = get_all_textureRect(child)
		items += child_items

	return items
	
func status_texture_button(dict: Dictionary):
	disable_all_items()
	var local_dict = dict.duplicate()
	for item in items_container.filter(func(obj): return obj.get_parent().modulate == Color.DARK_GRAY):
		if local_dict.has(item.name) && local_dict[item.name] > 0:
			item.get_parent().modulate = Color.WHITE
			local_dict[item.name] -= 1
			
	if items_container.all(func(obj): return obj.get_parent().modulate == Color.WHITE):
		activate_item()
		
func activate_item():
	item_actif.get_parent().modulate = Color.WHITE
	item_actif.pressed.connect(item_selected)
		
func disable_all_items():
	item_actif.get_parent().modulate = Color.DARK_GRAY
	items_container.map(func(obj): obj.get_parent().modulate = Color.DARK_GRAY)
	
	if item_actif.pressed.is_connected(item_selected):
		item_actif.pressed.disconnect(item_selected)
	
func is_not_selected():
	return item_actif.get_parent().modulate != Color.GOLD

func item_selected():
	item_actif.get_parent().modulate = Color.GOLD
	ServiceScenes.items.item_bought(self)

func displayStats(item):
	if !ServiceScenes.items == null:
		ServiceScenes.items.displayStats(item)
