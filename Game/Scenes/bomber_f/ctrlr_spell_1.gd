extends IControllerKeyPressed

var champion
var shoots

func _ready():
	if is_multiplayer_authority():
		key = KEY_A
		coltdown_time = 5
		champion = ServiceScenes.championNode
		
		await super._ready()
		shoots = $dp_shoot_1.get_children().filter(func(s): return s is IActive)

func active():
	super.active()
	var main_vector = get_global_mouse_position() - champion.position
		
	shoots.map(func(s): s.can_active(main_vector))

