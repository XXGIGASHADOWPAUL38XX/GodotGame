extends IDamagingSpell

var speed = 20.0
var angle_incl_start = -30
var animation

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 5.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		
		animation = $anim_shoot_2

func active(main_mector):
	self.position = champion.position + ServiceSpell.set_in_front_mouse_incl(self, get_global_mouse_position(), 40, angle_incl_start)
	self.rotation = main_mector.angle()
	self.show()

	for i in range(10):
		self.position += (main_mector.normalized() * speed)
		await get_tree().create_timer(0).timeout
		
	self.hide()
	
	spells_placeholder.get_inactive_bomb().can_active(self.position)
