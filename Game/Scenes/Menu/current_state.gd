extends PanelContainer

@onready var logo = $MarginContainer/logo

var logo_mapping = {
	'play_1v1': preload("res://Game/Ressources/UI/Menu/logo_1v1.png"),
	'play_2v2': preload("res://Game/Ressources/UI/Menu/logo_2v2.png"),
	'champions': preload("res://Game/Ressources/UI/Menu/champion.png"),
	'settings': preload("res://Game/Ressources/UI/Menu/settings.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_current_mode():
	return ServiceScenes.menu_scene.game_mode_phldr.current_plhdr

func update_logo(logo_name: String):
	logo.get_theme_stylebox("panel", "Panel").texture = logo_mapping[logo_name.to_lower()]
