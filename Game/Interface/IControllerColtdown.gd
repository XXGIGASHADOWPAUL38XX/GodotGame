extends IControllerActive

class_name IControllerColtdown

var coltdown_time
var coltdown

var service_time = preload("res://Game/Services/service_time.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		coltdown = service_time.init_timer(self, coltdown_time)
		cond_spells.append(Callable(self, 'no_remaining_cd'))
		await super._ready()

func no_remaining_cd():
	print(coltdown.time_left)
	return coltdown.time_left == 0
