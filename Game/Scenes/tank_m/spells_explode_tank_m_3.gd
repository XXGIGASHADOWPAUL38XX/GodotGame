extends IDamagingSpell

var animation: AnimatedSprite2D
var ready_to_explode = false

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.12
		# ------------------------------------ #
		
		await super._ready()
		animation = $anim_exp_tank_m_3
	
func explode():
	self.position = spell_controller.rock.position
	self.scale = Vector2(1, 1)
	self.modulate.a = 1
	self.show()
	
	for i in range(12):
		self.scale += Vector2(0.04, 0.04)
		self.modulate.a -= 0.08
		await get_tree().create_timer(0).timeout
		
	self.hide()
