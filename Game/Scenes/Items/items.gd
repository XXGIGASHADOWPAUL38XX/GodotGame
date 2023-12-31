extends Control

var orbs_grid: GridContainer
var items_container: VBoxContainer

var item_class = preload("res://Game/Classes/Item/item.gd").new()
var actif_class = preload("res://Game/Classes/Actifs/actifs.gd").new()
var actif

var camera
var key_p_pressed = false
var mouse_l_pressed = false

var orbs = []
var items = []
var number_orb
var orb_dict: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.items = self
	camera = ServiceScenes.getCamera()
	number_orb = $PanelContainer/VBoxContainer/Orbs/Actifs/GridContainer/MarginContainer/general_orb_panel/number
	orbs_grid = $PanelContainer/VBoxContainer/Orbs/Actifs/GridContainer as GridContainer
	items_container = $PanelContainer/VBoxContainer/Items
	
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

func on_click_actif(orb: TextureButton):
	var champion = ServiceScenes.champion.name
	Servrpc.any(self, 'on_click_actif_rpc', [orb.get_name(), ServiceScenes.championNode, Server.get_actual_player()])
	ServiceAnimations.set_animation(ServiceScenes.championNode, 'animation_upgraded')
	ServiceAnnounce.set_announce(
		champion + ' purchased orb active : ' + orb.get_name(),
		'res://Game/Ressources/Heros/icons/' + champion  + '.png',
		orb.texture_normal.resource_path, champion
	)
#	disable_actifs()

func on_click_actif_rpc(orb, champion, id):
	var active_orb = load("res://Game/Scenes/Orbs_active/" + orb + "_active.tscn").instantiate()
	active_orb.set_multiplayer_authority(id)
	champion.add_child(active_orb)

func orb_gained(item_name, label_number):
	if int(number_orb.text) > 0:
		label_number.text = str(int(label_number.text) + 1)
		number_orb_value(int(number_orb.text) - 1)
		if orb_dict.has(item_name):
			orb_dict[item_name] += 1
		else:
			orb_dict[item_name] = 1
		
		items.filter(func(IItem): return IItem.is_not_selected()).map(func(IItem): IItem.status_texture_button(orb_dict))
		item_stats(item_name)
		
func item_bought(item):
	orb_dict = {}
	items.filter(func(IItem): return IItem.is_not_selected()).map(func(IItem): IItem.status_texture_button(orb_dict))
	item_stats(item)
	
func item_stats(item_name):
	var item = item_class.get(item_name)
	Servrpc.any(ServiceStats, 'update_stats_from_item', [ServiceScenes.championNode, item])
	get_parent().get_node('stats_heros').update_stats_local()

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


