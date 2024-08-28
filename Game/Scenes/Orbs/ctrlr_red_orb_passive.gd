extends IControllerActive

func after_ready():
	if is_multiplayer_authority():
		ServiceScenes.championNode.func_hit.append(Callable(self, 'can_active'))
		await super.after_ready()

func active():
	super.active()
	$red_orb_passive.can_active()
