extends ProgressBar

var main

func _ready():
	self.value = 100
	main = get_parent().get_parent().get_parent()

func _process(_delta):
	if (get_parent().get_parent().is_multiplayer_authority()):
		main.SHE_get_changes(self)
