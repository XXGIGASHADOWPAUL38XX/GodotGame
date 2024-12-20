extends Control

@onready var play_button = $margin/Vbox/Play
@onready var cancel_button = $margin/Vbox/Cancel
@onready var gamemodes = $margin/Vbox/PanelContainer/MarginContainer/Vbox/Gamemodes

# Called when the node enters the scene tree for the first time.
func _ready():
	var nb_players_game_mapping = {
		$margin/Vbox/PanelContainer/MarginContainer/Vbox/Gamemodes/one_vs_one: 2,
		$margin/Vbox/PanelContainer/MarginContainer/Vbox/Gamemodes/two_vs_two: 4,
	}
	
	ServiceScenes.CONFIG_NB_PLAYERS_GAME = 2
	
	gamemodes.get_children().map(func(button):
		button.pressed.connect(func(): ServiceScenes.CONFIG_NB_PLAYERS_GAME = nb_players_game_mapping[button])
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_pressed():
	ServiceScenes.menu_scene.queue_panel.add_to_queue_1v1()

	play_button.hide()
	cancel_button.show()
	
func _on_cancel_pressed():
	ServiceScenes.menu_scene.queue_panel.remove_to_queue()
	
	cancel_button.hide()
	play_button.show()
