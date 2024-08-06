extends IEntity

func _ready():
	if is_multiplayer_authority():
		ServiceScenes.allEnnemiesNode.append(self)
		func_hitted = [Callable(self, 'take_damage')]
