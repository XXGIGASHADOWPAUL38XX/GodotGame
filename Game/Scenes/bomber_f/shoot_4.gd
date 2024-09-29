extends IDamagingSpell

const ANGLE_RANGE = 20
var speed = 12.0
var angle

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 2.0
		damage_ratio = 0.03
		# ------------------------------------ #
		
		await super._ready()
		func_on_entity_entered.append(Callable(self, 'push_ennemy'))
		
		self.hide()
		
		animation = $anim_shoot_4

func active():
	var main_mector = (get_global_mouse_position() - champion.position).rotated(deg_to_rad(angle))
	self.position = champion.position + ServiceSpell.set_in_front_mouse_incl(self, get_global_mouse_position(), 40, angle)
	self.rotation = main_mector.angle()
	self.show()

	for i in range(15):
		self.position += (main_mector.normalized() * speed)
		await get_tree().create_timer(0).timeout
		
	self.hide()
	
	spells_placeholder.get_inactive_bomb().active(self.position)

func post_dp_script(id, nbr_dupl):
	var difference_angle = (ANGLE_RANGE * 2) / (nbr_dupl - 1)
	angle = ANGLE_RANGE - (difference_angle * (id - 1))

func push_ennemy():
	ServiceSpell.push_ennemy_global(self, player_hitted, 8)
