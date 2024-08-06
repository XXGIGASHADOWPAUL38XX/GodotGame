extends IDamagingSpell

var speed = 20.0
var cd = 8.0
var spell: AnimatedSprite2D
var target_position = Vector2.ZERO
var coltdown = Timer
var HUD
var coltdown_spell4
var cd_spell4 = 2.0

const orb_kind = MageOrb.OrbKind.GOLD

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 5.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		
		spell = $Spells_mage_ult
		coltdown_spell4 = service_time.init_timer(self, cd_spell4)

func _process(_delta):
	if is_multiplayer_authority() && orb_kind == champion.orb_kind:
		pass

func active():
	spell.play("spell")
	self.scale = Vector2(0.08, 0.08)
	self.modulate.a = 1
	self.position = champion.orb.position
	self.show()
	
	for i in range(200):
		self.scale += Vector2(0.02, 0.02)
		await get_tree().create_timer(0.016).timeout
		self.modulate.a -= 0.025
		
	spell.stop()
