extends "res://Game/Interface/IDamagingSpell.gd"

var animation

func _ready():
	animation = $spells_healer_f_1_anim
	self.func_on_entity_entered.append(Callable(get_parent().get_node('animations').get_node('mark_stun'), 'marked'))

func _process(_delta):
	pass
			




