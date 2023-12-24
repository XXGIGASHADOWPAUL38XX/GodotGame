extends "res://Game/Interface/IDamagingSpell.gd"

func _ready():
	if is_multiplayer_authority():
		super._ready()
		self.func_on_entity_entered.append(Callable(get_parent().get_node('target_ranger_m_3'), 'marked').bind(self))


