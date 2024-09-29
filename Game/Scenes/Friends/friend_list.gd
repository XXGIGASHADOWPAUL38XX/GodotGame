extends Control

var player_controller = PlayerController.new()
@onready var form_add_friend = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/PanelContainer2/VBoxContainer/form_add_friend
@onready var friend_name = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/PanelContainer2/VBoxContainer/form_add_friend/HBoxContainer/friend_name

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_add_friend_toggled(toggled_on):
	form_add_friend.visible = toggled_on

func _on_confirm_add_pressed():
	var player = await player_controller.get_player(friend_name.text)
	if player.size() == 0:
		return PlayerException.LoginException.USERNAME_INCORRECT
		
	player = player[0]
	

