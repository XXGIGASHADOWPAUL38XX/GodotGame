extends Control

@onready var orbs_grid: GridContainer = $PanelContainer/VBoxContainer/Orbs/Actifs/GridContainer
@onready var items_container: VBoxContainer = $PanelContainer/VBoxContainer/CenterContainer/ScrollContainer/Items
@onready var number_orb = $PanelContainer/VBoxContainer/Orbs/Actifs/GridContainer/MarginContainer/general_orb_panel/number

var item_class = preload("res://Game/Classes/Item/item.gd").new()
var actif_class = preload("res://Game/Classes/Actifs/actifs.gd").new()
var actif

var camera
var key_p_pressed = false

var orbs = []
var items = []
var orb_dict: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.items = self
	camera = ServiceScenes.camera
	
	self.visibility_changed.connect(func():
		if self.visible:
			ServiceScenes.main_scene.move_child(self, ServiceScenes.main_scene.get_child_count() - 1)
	)
	
	number_orb_value(4)
	
	orbs = get_all_textureButton(orbs_grid)
	items = items_container.get_children()

	for orb in orbs:
		var panel = orb.get_parent() as Panel
		var label_number = panel.get_node("number")
		label_number.text = str(0)
		
		panel.mouse_entered.connect(mouse_panel.bind(panel))
		panel.mouse_exited.connect(mouse_panel.bind(panel))
		panel.mouse_entered.connect(displayStats.bind(item_class.get(orb.name)))
		orb.pressed.connect(orb_gained.bind(orb.name, label_number))

func get_all_textureButton(node: Control):
	var orbs = []
	if node is TextureButton:
		orbs.append(node)

	for child in node.get_children():
		var child_orbs = get_all_textureButton(child)
		orbs += child_orbs

	return orbs

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = Vector2(camera.offset)
	
	if Input.is_key_pressed(KEY_P):
		if key_p_pressed == false:
			self.visible = !self.visible
			key_p_pressed = true
	else:
		key_p_pressed = false
		
func filter(param):
	for item in orbs_grid.get_children():
		var textureButton = item.get_child(0) as TextureButton
		textureButton.visible = item_class.get_list_by_category(param).has(textureButton.get_name())

func displayStats(item):
	$PanelContainer/VBoxContainer/MarginContainer/PanelContainer/Margin/Label.text = ''
	for property in item.get_property_list():
		if (property.type == TYPE_FLOAT && item.get(property.name) != 0.0) || property.name == 'desc':
			$PanelContainer/VBoxContainer/MarginContainer/PanelContainer/Margin/Label.text += (
				property.name.to_upper() + ' : ' + str(item.get(property.name))) + '\n'
				
func mouse_panel(panel):
	if panel.modulate == Color.WHITE:
		panel.modulate = Color.GRAY
		return
	panel.modulate = Color.WHITE

func load_active(orb: Control):
	var orb_texture_button = orb.item_actif
	
	ServiceOrbs.instanciate_orb(orb.get_name())
	ServiceAnimations.set_animation(ServiceScenes.championNode, 'animation_upgraded')
	
	for i in range(3):
		ServiceAnnounce.set_announce(
			ServiceScenes.championNode.name + ' purchased orb active : ' + orb.get_name(),
			'res://Game/Ressources/Heros/icons/' + ServiceScenes.championNode.name  + '.png',
			orb_texture_button.texture_normal.resource_path, ServiceScenes.championNode
		)
		
		await get_tree().create_timer(0.4).timeout
#	disable_actifs()

func orb_gained(item_name, label_number):
	if int(number_orb.text) == 0:
		return 
		
	label_number.text = str(int(label_number.text) + 1)
	number_orb_value(int(number_orb.text) - 1)
	
	if orb_dict.has(item_name):
		orb_dict[item_name] += 1
	else:
		orb_dict[item_name] = 1
	
	ServiceScenes.HUD.update_items(orb_dict)
	update_status_items(item_name)
		
func item_bought(orb):
	orb_dict[orb.item_actif.name] = 1
	
	for IItem in orb.items_container:
		if orb_dict[IItem.name] == 1:
			orb_dict.erase(IItem.name)
		else:
			orb_dict[IItem.name] -= 1
	
	ServiceScenes.HUD.update_items(orb_dict)
	update_status_items(orb.item_actif.name)
	var item_texture = items_container.get_children().filter(
		func(x): return x.get_name().to_lower() == orb.name.to_lower())[0]
		
	load_active(item_texture)
	
func item_stats(item_name):
	var item = item_class.get(item_name)
	ServiceStats.update_stats_from_item(ServiceScenes.championNode, item)
	ServiceScenes.HUD.display_stats()

func on_click_passive_rpc(orb, champion, id):
	var passive_orb = load("res://Game/Scenes/Orbs_passive/" + orb + "_passive.tscn").instantiate()
	passive_orb.set_multiplayer_authority(id)
	champion.add_child(passive_orb)
	
func number_orb_value(number):
	number_orb.text = str(int(number))
	orbs.map(func(obj): 
		obj.disabled = int(number_orb.text) == 0
		obj.get_parent().modulate = Color.DARK_GRAY if int(number_orb.text) == 0 else Color.WHITE
	)

func update_status_items(item_name):
	items.filter(func(IItem): return IItem.is_not_selected()).map(
		func(IItem): IItem.status_texture_button(orb_dict))
	item_stats(item_name)
