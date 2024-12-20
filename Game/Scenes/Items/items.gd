extends Control

var camera
var key_p_pressed = false
@onready var actives = $PanelContainer/MarginContainer/main_vbox/actives
@onready var info_label = $PanelContainer/MarginContainer/main_vbox/MarginContainer/PanelContainer/Margin/info_label
@onready var kind_choice = $PanelContainer/MarginContainer/main_vbox/panel_choice/MarginContainer/VBoxContainer/CenterContainer/Vbox/kind_choice

@onready var mapping_kind_choice_nodes = {
	"active_mode": $PanelContainer/MarginContainer/main_vbox/actives,
	"vision_mode": $PanelContainer/MarginContainer/main_vbox/visions
}

var color_selected = Color(0.5, 0.5, 0.5, 0.5)
var color_not_selected = Color(0, 0, 0, 0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.shop = self
	camera = ServiceScenes.camera
	
	var buttons_login_signup = kind_choice.get_children()
	
	buttons_login_signup.map(func(button_pressed: Button):
		button_pressed.pressed.connect(func():
			var previous_button = kind_choice.get_children().filter(func(b): return b != button_pressed)[0]
			
			$PanelContainer/MarginContainer/main_vbox.get_children().filter(func(c): return c is IShopInterface).map(func(ishop):
				ishop.visible = ishop == mapping_kind_choice_nodes[button_pressed.name]
			)
		
			buttons_login_signup.map(func(button2):
				var bg_color = color_selected if button_pressed == button2 else color_not_selected
				button2.get_theme_stylebox("normal", "Button").bg_color = bg_color
				
				var font_color = Color.BLACK if button_pressed == button2 else Color.WHITE
				button_pressed.add_theme_color_override('font color', font_color)
			)
		)
	)
	
	self.visibility_changed.connect(func():
		if self.visible:
			ServiceScenes.main_scene.move_child(self, ServiceScenes.main_scene.get_child_count() - 1)
	)

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
	pass
	##!!
	#for item in orbs_grid.get_children():
		#var textureButton = item.get_child(0) as TextureButton
		#textureButton.visible = item_class.get_list_by_category(param).has(textureButton.get_name())
		
func displayStats(item):
	info_label.text = ''
	for property in item.get_property_list():
		if (property.type == TYPE_FLOAT && item.get(property.name) != 0.0) || property.name == 'desc':
			info_label.text += (
				property.name.to_upper() + ' : ' + str(item.get(property.name))) + '\n'

