extends IDamagingSpell

var speed = 20.0
var throw_direction = Vector2.RIGHT
var cd_spell = 5.0
var spell: AnimatedSprite2D
var coltdown_spell: Timer
var HUD

const orb_kind = MageOrb.OrbKind.GOLD

func _ready():	
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.2
		# ------------------------------------ #
		
		await super._ready()
		
		spell = $Spells_mage_explode as AnimatedSprite2D
		coltdown_spell = service_time.init_timer(self, cd_spell)
		
		frame_based_anim()

func _process(_delta):
	if is_multiplayer_authority() && orb_kind == champion.orb_kind:
		pass
		
func active():
	self.position = champion.orb.position
	self.show()
	spell.play("spell2_explode")

	await get_tree().create_timer(1).timeout
		
	spell.stop()
	self.hide()

func frame_based_anim():
	var avg_frame = (spell.sprite_frames.get_frame_count(spell.animation) - 1) * 0.5
	var threshold = avg_frame * 0.5
	spell.frame_changed.connect(func():
		var ratio = max(0, abs(avg_frame - spell.frame) - threshold)
		self.modulate.a = 1 / (1 + (ratio))
	)
	
