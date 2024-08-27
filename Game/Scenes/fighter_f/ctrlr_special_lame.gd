extends IControllerHoldable

var special_lame
var special_dashes

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = KEY_D
		coltdown_time = 7
		timer_key_release_cd = 10
		
		await super._ready()
		
		special_lame = $special_lame
		special_dashes = $dp_special_dash.get_children().filter(func(lame): return lame is IActive)

func active():
	super.active()special_lame.active()

func stop_spell():
	super.stop_spell()
	special_lame.stop_spell()

