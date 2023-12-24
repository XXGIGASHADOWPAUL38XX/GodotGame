extends "res://Game/Interface/IDamagingSpell.gd"

var animation: AnimatedSprite2D
var ready_to_explode = false

func _ready():
	if is_multiplayer_authority():
		super._ready()
		animation = $anim_exp_tank_m_3
	
func explode():
	self.global_position = get_parent().get_node('rock_tank_m_3').global_position
	self.scale = Vector2(1, 1)
	self.modulate.a = 1
	self.show()
	
	for i in range(12):
		self.scale += Vector2(0.04, 0.04)
		self.modulate.a -= 0.08
		await get_tree().create_timer(0).timeout
		
	self.hide()
