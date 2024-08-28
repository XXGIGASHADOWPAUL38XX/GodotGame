extends IDamagingSpell

var RANGE_ANGLE_INCL = 30

var speed = 10.0
var angle_incl_start
var delay

func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 5.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super.after_ready()
		self.hide()
		
		animation = $anim_shoot_1

func active(main_mector):
	await get_tree().create_timer(delay).timeout
	self.position = champion.position + ServiceSpell.set_in_front_mouse_incl(self, get_global_mouse_position(), 40, angle_incl_start)
	self.rotation = main_mector.angle()
	self.show()

	for i in range(20):
		self.position += (main_mector.normalized() * speed)
		await get_tree().create_timer(0).timeout
		
	self.hide()
	
	spells_placeholder.get_inactive_bomb().can_active(self.position)

func post_dp_script(id, nbr_dupl):
	var difference_angle = (RANGE_ANGLE_INCL * 2) / (nbr_dupl - 1)
	angle_incl_start = RANGE_ANGLE_INCL - (difference_angle * (id - 1))
	delay = 0 + (0.3 * (id - 1))
