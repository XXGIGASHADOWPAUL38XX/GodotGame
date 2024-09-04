extends IControllerKeyPressed

var anims_block

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_active_item']
		coltdown_time = 12
		await super._ready()
		
		anims_block = $dp_anim_blocked.get_children().filter(func(c): return c is IAnimation)

func active():
	await super.active()
	$orange_orb_active.active()

func get_inactive_anim_block():
	return anims_block.filter(func(anim_block): return !anim_block.visible).pick_random()
	
