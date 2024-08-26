extends IControllerColtdown

class_name IControllerKeyPressed

var key
var key_pressed: bool = false

func _input(event):
	if is_multiplayer_authority() && ((event is InputEventKey && event.keycode == key) || (event is InputEventMouseButton && event.button_index == key)):
		if event.is_pressed():
			can_active()

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		await super._ready()

func can_active():
	if cond_spells.all(func(c: Callable): return c.call()):
		self.active()
