extends IDamagingSpell

var speed = 20.0
var animation
var throw_direction

var base_angle: float = 0
var duplicator

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super._ready()
		animation = $spells_warrior_anim_4_hit
		
		duplicator = self.get_parent()

func _process(_delta):
	if is_multiplayer_authority():
		pass

func active():
	self.position = champion.position + ServiceSpell.set_in_front(champion, 10, base_angle)
	self.throw_direction = (get_global_mouse_position() - self.position).rotated(deg_to_rad(base_angle))
	self.rotation = throw_direction.angle()
	
	self.show()
	animation.play()

	for i in range(30):
		self.position += throw_direction.normalized() * 6
		await get_tree().create_timer(0).timeout
	
	animation.stop()
	self.hide()

func post_dp_script(id, nbr_dupl):
	base_angle = (id - 1) * 90
