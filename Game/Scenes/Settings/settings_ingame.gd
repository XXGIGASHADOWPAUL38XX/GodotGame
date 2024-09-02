extends Control

@onready var camera_ssiblty_slider = $margin/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/HSlider
var key_escape_pressed
var resource_awaiter = ResourceAwaiter.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visibility_changed.connect(func():
		if self.visible:
			ServiceScenes.main_scene.move_child(self, ServiceScenes.main_scene.get_child_count() - 1)
	)
	
	set_multiplayer_authority(Server.get_client_id())
	ServiceScenes.settings_scene = self
		
	camera_ssiblty_slider.value = ServiceScenes.settings_scene_cvalue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		if key_escape_pressed == false:
			self.visible = !self.visible
			key_escape_pressed = true
	else:
		key_escape_pressed = false
		
	self.position = ServiceScenes.camera.offset

func _exit_tree():
	ServiceScenes.settings_scene_cvalue = camera_ssiblty_slider.value
	
