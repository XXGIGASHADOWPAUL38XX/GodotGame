extends IDamagingSpell
 


var HUD: Control

var number_orb: int

var angle: float
var spread_speed: float = 8
var throw_speed: float = 15

const orb_kind = MageOrb.OrbKind.BLUE

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING spell #
		damage_base = 6.0
		damage_ratio = 0.2
		# ------------------------------------ #
		
			
		await super.after_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority() && champion.orb_kind == orb_kind:
		pass
		#if (HUD == null):
			#HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		#else:
			#HUD.bindTo(coltdown, 4)

func active(matching_orb_s_2):
	self.position = matching_orb_s_2.position
	var rotation_vector = get_global_mouse_position() - matching_orb_s_2.position
	
	self.show()
	animation.play()
	for i in range(25):
		self.rotation = rotation_vector.angle()
		self.position += rotation_vector.normalized() * throw_speed
		await get_tree().create_timer(0).timeout
		
	self.hide()

func post_dp_script(id, nbr_dupl):
	self.number_orb = id
