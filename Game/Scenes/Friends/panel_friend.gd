extends PanelContainer

var friend
var duplicator
var resource_awaiter = ResourceAwaiter.new()

@onready var friend_name = $VBoxContainer/friend_name
@onready var level = $VBoxContainer/HBoxContainer/level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func post_dp_script(id, dp_number):
	duplicator = get_parent().get_node("dp_panel_friend")
	
	friend = duplicator.friends[id - 1]
	friend_name.text = friend["username"]
	level.text = "1"
	
	self.show()

func _on_invite_button_pressed():
	pass # Replace with function body.
