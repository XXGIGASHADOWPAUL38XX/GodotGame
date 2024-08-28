extends IControllerColtdown

class_name IControllerKeyPressed

var key
var key_pressed: bool = false

var cast_time = null
var cast_timer: Timer

func _input(event):
	if is_multiplayer_authority() && ((event is InputEventKey && event.keycode == key) || (event is InputEventMouseButton && event.button_index == key)):
		if event.is_pressed():
			can_active()

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		cond_spells.append(Callable(self, 'is_not_impaired'))
		
		if cast_time != null:
			cast_timer = service_time.init_timer(self, cast_time)
		
		await super.after_ready()

func can_active():
	if cond_spells.all(func(c: Callable): return c.call()):
		self.active()

func active():
	if cast_time != null:
		ServiceScenes.championNode.add_state(self, 'states_action', State.StateAction.IMMOBILE, cast_time)
		cast_timer.start()
		await cast_timer.timeout
		
	coltdown.start()
	
func is_not_impaired():
	return ServiceScenes.championNode.curr_state_action.state != State.StateAction.STUNNED
