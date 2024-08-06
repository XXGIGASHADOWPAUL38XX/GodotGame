extends IDamagingSpell

var speed = 16.0
var throw_direction = Vector2.RIGHT
var cd_spell1 = 3.0
var cd_spell3 = 7.0
var spell: AnimatedSprite2D
var coltdown_spell: Timer
var HUD

const orb_kind = MageOrb.OrbKind.GOLD

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 9.0
		damage_ratio = 0.25
		# ------------------------------------ #
		
		await super._ready()
		
		spell = $Spells_mage_anim
		
		coltdown_spell = service_time.init_timer(self, cd_spell1)

func _process(delta):
	if is_multiplayer_authority() && orb_kind == champion.orb_kind:
		if Input.is_key_pressed(KEY_A) && coltdown_spell.time_left == 0:
			coltdown_spell.start()
			spell_launch()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell, 1)
			
func spell_launch():
	spell.play("spell_launch")
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 30)
	
	var direction = get_global_mouse_position() - position
	direction = direction.normalized()

	self.show()
	for i in range(12):
		self.position += direction * speed
		await get_tree().create_timer(0).timeout

