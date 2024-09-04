extends Control

@onready var camera_ssiblty_slider = $margin/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/HSlider
var key_escape_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	if ServiceScenes.settings_scene_cvalue != null:
		camera_ssiblty_slider.value = ServiceScenes.settings_scene_cvalue
	ServiceScenes.settings_scene = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _exit_tree():
	ServiceScenes.settings_scene_cvalue = camera_ssiblty_slider.value
	
