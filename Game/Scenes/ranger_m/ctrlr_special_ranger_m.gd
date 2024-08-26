extends IControllerHoldable

var specials

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = KEY_D
		coltdown_time = 8
		timer_key_release_cd = 0.75
		
		await super._ready()
	
		specials = $special_ranger_m.get_children().filter(func(s): return s is IActive)

func active():
	specials.map(func(s): 
		if !key_pressed_bool:
			return
			
		s.active()
		await get_tree().create_timer(0.16).timeout
	)
