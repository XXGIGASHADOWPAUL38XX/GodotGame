extends "res://Game/Interface/IEntity.gd"

func _ready():
	if is_multiplayer_authority():
		func_hitted = [Callable(self, 'take_damage')]
