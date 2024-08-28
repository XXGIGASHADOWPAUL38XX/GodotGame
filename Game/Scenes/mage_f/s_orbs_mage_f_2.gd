extends IDamagingSpell
 
var distance_to_champion: float = 35.0
var rotation_sp2_speed: float = 1.2
var rotation_sp4_speed: float = 2 
var current_angle: float = 0.0
var delta_estimated: float = 0.0167
var spell: AnimatedSprite2D

var duplicator: Node2D
var HUD: Control

var number_orb: int

var angle: float
var spread_speed: float = 2.5
var throw_speed: float = 15
var comeback_speed: float = 6

var should_rotate_champ: bool = false

const orb_kind = MageOrb.OrbKind.BLUE

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING spell #
		damage_base = 6.0
		damage_ratio = 0.2
		# ------------------------------------ #
		
		duplicator = self.get_parent()
		spell = $anim_orbs_mage_f_2 as AnimatedSprite2D
		
		await super.after_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority() && champion.orb_kind == orb_kind:
		if should_rotate_champ:
			rotate_arround_champ(delta)
			
		#if (HUD == null):
			#HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		#else:
			#HUD.bindTo(coltdown_spell_2, 2)

func post_dp_script(id, nbr_dupl):
	self.number_orb = id
	self.angle = (id - 1) * 90
	
func active():
	should_rotate_champ = false
	self.position = champion.orb.position + ServiceSpell.set_in_front(champion.orb, 10, angle)
	self.rotation = deg_to_rad(angle) 
	
	var direction = (get_global_mouse_position() - position).normalized()

	self.show()
	spell.play()	
	
	# SEPARE
	for i in range(10):
		self.position += Vector2(1, 0).rotated(rotation) * spread_speed
		await get_tree().create_timer(0).timeout
		
	# ROTATE
	var distance_to_orb = self.position.distance_to(champion.orb.position)
	for i in range(15):
		current_angle += rotation_sp2_speed * delta_estimated
		direction = Vector2(cos(current_angle), sin(current_angle)).rotated(deg_to_rad(angle))
		self.rotation = direction.angle()
		self.position = champion.orb.position + (distance_to_orb * direction)
		await get_tree().create_timer(0).timeout
		
	# COME BACK
	while !ServiceSpell.is_close_to(self, champion, 30):
		self.position += (champion.position - self.position).normalized() * comeback_speed
		await get_tree().create_timer(0).timeout
		
	should_rotate_champ = true

func activation_f4():
	self.hide()

func rotate_arround_champ(delta_estimated):
	current_angle += rotation_sp4_speed * delta_estimated
	var direction = Vector2(cos(current_angle), sin(current_angle)).rotated(deg_to_rad(angle))
	self.rotation = direction.angle()
	self.position = champion.position + (distance_to_champion * direction)
