extends IControllerActive

func _ready():
	if is_multiplayer_authority():
		ServiceScenes.championNode.func_hit.append(Callable(self, 'can_active'))
		await super._ready()

func active():
	await super.active()
	$red_orb_passive.active()
