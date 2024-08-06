extends IDamagingSpell

var speed = 20.0
var cd = 8.0
var spell1: AnimatedSprite2D
var target_position = Vector2.ZERO
var HUD
var coltdown_spell4
var cd_spell4 = 2.0
var ready_to_launch: bool = false

const orb_kind = MageOrb.OrbKind.BLUE

var fixed_number_orb = 0
var current_number_orb = 1
const MAX_NUMBER_ORB = 4

var main_dp_authority

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 7.0
		damage_ratio = 0.2
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		
		spell1 = $Spells_mage_ult
		coltdown_spell4 = service_time.init_timer(self, cd_spell4)

func _process(_delta):
	if is_multiplayer_authority() && ready_to_launch:
		
		rotate_arround_champ()
		
		if Input.is_key_pressed(KEY_SPACE) && coltdown_spell4.time_left == 0:
			if current_number_orb == fixed_number_orb:
				spell_launch()
								
				if current_number_orb == MAX_NUMBER_ORB: 
					current_number_orb = 0
				
				if main_dp_authority:
					coltdown_spell4.start()
					
				current_number_orb += 1
					
		if main_dp_authority:
			if (HUD == null):
				HUD = ServiceScenes.getMainScene().get_node('stats_heros')
			else:
				HUD.bindTo(coltdown_spell4, 4)

func spell_launch():
	ready_to_launch = false
	spell1.play("spell1")
	
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 25)
	var direction = get_global_mouse_position() - position
	direction = direction.normalized()
	self.show()
		
	for j in range(10):
		self.position += direction * speed
		await get_tree().create_timer(0).timeout
		
	self.hide()
		
	spell1.stop()

func ready_to_launch_f(orb_from_spell_2):
	self.position = orb_from_spell_2.position
	ready_to_launch = true
	await get_tree().create_timer(5).timeout
	
	ready_to_launch = false
	
func post_dp_script(id):
	self.number_orb = id
	self.main_dp_authority = id == MAX_NUMBER_ORB

func rotate_arround_champ():
	pass
