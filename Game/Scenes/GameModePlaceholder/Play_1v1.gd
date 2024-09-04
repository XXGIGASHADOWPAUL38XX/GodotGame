extends Control

@onready var play_button = $margin/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Play
@onready var cancel_button = $margin/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Cancel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_pressed():
	ServiceScenes.menu_scene.queue_panel.add_to_queue()
	
	ServiceScenes.menu_scene.play()
	
	play_button.hide()
	cancel_button.show()
	
func _on_cancel_pressed():
	ServiceScenes.menu_scene.queue_panel.remove_to_queue()
	
	cancel_button.hide()
	play_button.show()
