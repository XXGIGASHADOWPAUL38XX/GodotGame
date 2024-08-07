extends IDamagingSpell

const ANGLE_RANGE = 20
var speed = 12.0
var angle
var animation

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 5.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super._ready()
		func_on_entity_entered.append(Callable(self, 'push_ennemy_global'))
		
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

func push_ennemy_global():
	Servrpc.send_to_id(player_hitted.get_multiplayer_authority(), self, 'push_ennemy', [player_hitted])

func push_ennemy(ennemy): #AT RUNTIME, MULTIPLAYER_AUTHORITY IS ON ENNEMY VIA A RPC CALL
	var retry_instance = 2
	var old_position = self.position 
	var position_differencial = ennemy.position - self.position
	
	for i in range(8):
		if self.position == old_position && i >= (retry_instance - 1):
			return
		ennemy.position = self.position + position_differencial
		await get_tree().create_timer(0).timeout
