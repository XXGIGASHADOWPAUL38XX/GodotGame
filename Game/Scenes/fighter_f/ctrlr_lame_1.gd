extends IControllerKeyPressed

var champion

func _ready():
	if is_multiplayer_authority():
		key = KEY_A
		coltdown_time = 2
		await super._ready()
		
		champion = ServiceScenes.championNode

func active():
	super.active()
	var base_destination = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 250)
	
	$lame_1.can_active(base_destination)
	await get_tree().create_timer(0.25).timeout
	$lame_2.can_active(base_destination)

