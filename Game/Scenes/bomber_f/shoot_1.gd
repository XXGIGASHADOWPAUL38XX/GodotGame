extends IDamagingSpell

var RANGE_ANGLE_INCL = 30

var speed = 11.0
var angle_incl_start
var delay

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 5.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		
		animation = $anim_shoot_1

func active(main_mector):
	await get_tree().create_timer(delay).timeout
	self.position = champion.position + (main_mector.normalized() * 40).rotated(deg_to_rad(angle_incl_start))
	self.rotation = main_mector.angle()
	self.show()
	animation.play()

	for i in range(18):
		self.position += (main_mector.normalized() * speed)
		await get_tree().create_timer(0).timeout
		
	self.hide()
	
	spells_placeholder.get_inactive_bomb().active(self.position)

func post_dp_script(id, nbr_dupl):
	var difference_angle = (RANGE_ANGLE_INCL * 2) / (nbr_dupl - 1)
	angle_incl_start = RANGE_ANGLE_INCL - (difference_angle * (id - 1))
	delay = 0 + (0.3 * (id - 1))
