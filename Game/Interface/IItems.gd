extends Control

class_name IItems

var subitems_textureRects = []
var resource_awaiter = ResourceAwaiter.new()
@onready var item_actif: TextureButton = $margin/panel/item_actif
@onready var dp_node = get_node("./../dp_items")

# Called when the node enters the scene tree for the first time.
func _ready():
	disable_all_items()
	subitems_textureRects = self.get_children() \
		.filter(func(subnode): return subnode is Panel) \
		.map(func(subpanel): return subpanel.get_child(0))
	
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
	for item in subitems_textureRects.filter(func(obj): return obj.get_parent().modulate == Color.DARK_GRAY):
		if local_dict.has(item.name) && local_dict[item.name] > 0:
			item.get_parent().modulate = Color.WHITE
			local_dict[item.name] -= 1
			
	print(subitems_textureRects \
		.filter(func(textureRect): return textureRect.texture != null) \
		.map(func(obj): return obj.get_parent().modulate))
		
	if subitems_textureRects \
		.filter(func(textureRect): return textureRect.texture != null) \
		.all(func(obj): return obj.get_parent().modulate == Color.WHITE):
		item_actif.disabled = false
		item_actif.get_parent().modulate = Color.WHITE
		
func disable_all_items():
	item_actif.get_parent().modulate = Color.DARK_GRAY
	subitems_textureRects.map(func(obj): obj.get_parent().modulate = Color.DARK_GRAY)
	
func is_not_selected():
	return item_actif.get_parent().modulate != Color.GOLD


