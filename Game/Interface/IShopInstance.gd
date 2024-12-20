extends Control

class_name IShopInterface

var item_active_scene_path = func(item_name): return "res://Game/Scenes/items_passive/" + item_name + ".tscn"
var number_item_value

var items = []
var base_items = []
var dp_items = []
var item_dict: Dictionary = {}

@onready var items_grid: GridContainer = $items/Kind/CenterContainer/margin/Main/PanelContainer/MarginContainer/base_items_grid
@onready var items_container: VBoxContainer = $items/Kind/CenterContainer/margin/Main/ScrollContainer/items
@onready var number_item = $items/Kind/CenterContainer/margin/Main/PanelContainer/MarginContainer/base_items_grid/MarginContainer/general_item_panel/number
@onready var dp_items_node = $items/Kind/CenterContainer/margin/Main/ScrollContainer/items/dp_items
#@onready var dp_items_container = items_container.get_node("/dp_" + var_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.5).timeout
	set_number_item_value(number_item_value)

	base_items = items_grid.get_children().filter(func(c): return c is Panel).map(func(panel): 
		return panel.get_children().filter(func(c): return c is TextureButton)[0]
	)
	
	dp_items = items_container.get_children().filter(func(c): return c is IItems).map(func(iitem): 
		return iitem.item_actif
	)
	
	var clickable_items = base_items + dp_items
	var item_objects = dp_items_node.items + dp_items_node.subitems
	
	for unique_item in clickable_items:
		var matching_item_or_subitem = item_objects.filter(func(item): return item.name == unique_item.name)[0]
		var panel = unique_item.get_parent()
		
		unique_item.mouse_entered.connect(panel_entered.bind(panel))
		unique_item.mouse_exited.connect(panel_entered.bind(panel))
		unique_item.mouse_entered.connect(ServiceScenes.shop.displayStats.bind(matching_item_or_subitem)) 
		
		if unique_item in base_items:
			unique_item.pressed.connect(item_gained.bind(matching_item_or_subitem, unique_item.get_node("./../number"))) 
		elif unique_item in dp_items:
			unique_item.pressed.connect(item_bought.bind(matching_item_or_subitem)) 
		

func panel_entered(panel):
	if panel.modulate == Color.WHITE:
		panel.modulate = Color.GRAY
		return
	panel.modulate = Color.WHITE

func get_all_textureButton(node: Control):
	var items = []
	if node is TextureButton:
		items.append(node)

	for child in node.get_children():
		var child_items = get_all_textureButton(child)
		items += child_items

	return items

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
func filter(param):
	pass
	#for item in items_grid.get_children():
		#var textureButton = item.get_child(0) as TextureButton
		#textureButton.visible = item_class.get_list_by_category(param).has(textureButton.get_name())

func load_active(item: Control):
	var item_texture_button = item.item_actif
	
	ServiceItems.instanciate_item(item.get_name(), item_active_scene_path)
	ServiceAnimations.set_animation(ServiceScenes.championNode, 'animation_upgraded')
	ServiceAnnounce.set_announce(
		ServiceScenes.championNode.name + ' purchased item active : ' + item.get_name(),
		'res://Game/Ressources/Heros/hud_icons/' + ServiceScenes.championNode.name  + '.png',
		item_texture_button.texture_normal.resource_path, ServiceScenes.championNode
	)
		
#	disable_actifs()

func item_gained(item, label_number):
	if int(number_item.text) == 0:
		return 
		
	label_number.text = str(int(label_number.text) + 1)
	set_number_item_value(int(number_item.text) - 1)
	
	if item_dict.has(item.name):
		item_dict[item.name] += 1
	else:
		item_dict[item.name] = 1
	
	ServiceScenes.HUD.update_items(item_dict)
	ServiceStats.update_stats_from_item(ServiceScenes.championNode, item)	
	update_status_items(item.name)
		
func item_bought(item):
	item_dict[item.name] = 1
	
	for IItem in item.sub_items:
		if item_dict[IItem.name] == 1:
			item_dict.erase(IItem.name)
		else:
			item_dict[IItem.name] -= 1
	
	ServiceScenes.HUD.update_items(item_dict)
	update_status_items(item.name)
	print(items_container.get_children().map(func(x): return x.get_name().to_lower()))
	print(item.name.to_lower())
	var item_texture = items_container.get_children().filter(
		func(x): return x.get_name().to_lower() == item.name.to_lower())[0]
		
	load_active(item_texture)
	
func update_status_items(item):
	items.filter(func(IItem): return IItem.is_not_selected()).map(
		func(IItem): IItem.status_texture_button(item_dict))
	ServiceScenes.HUD.display_stats()

	
func set_number_item_value(number):
	number_item.text = str(int(number))
	base_items.map(func(obj): 
		obj.disabled = int(number_item.text) == 0
		obj.get_parent().modulate = Color.DARK_GRAY if obj.disabled else Color.WHITE
	)
