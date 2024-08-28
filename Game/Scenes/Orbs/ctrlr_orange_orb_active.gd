extends IControllerKeyPressed

var anims_block

func after_ready():
	if is_multiplayer_authority():
		key = KEY_F
		coltdown_time = 12
		await super.after_ready()
		
		anims_block = $dp_anim_blocked.get_children().filter(func(c): return c is IAnimation)

func active():
	super.active()
	$orange_orb_active.can_active()

func get_inactive_anim_block():
	return anims_block.filter(func(anim_block): return !anim_block.visible).pick_random()
	
