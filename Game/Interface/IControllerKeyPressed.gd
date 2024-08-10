extends IControllerColtdown

class_name IControllerKeyPressed

var key
var key_pressed: bool = false

func _input(event):
	if is_multiplayer_authority() && event is InputEventKey && event.keycode == key:
		if event.is_pressed():
			can_active()

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		cond_spells.append(Callable(self, 'key_released_pressed'))
		await super._ready()
		
func key_released_pressed():
	return Input.is_key_pressed(key) && key_pressed == false

func can_active():
	if cond_spells.all(func(c: Callable): return c.call()):
		self.active()
