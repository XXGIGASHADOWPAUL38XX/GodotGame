extends IDamagingSpell

var speed = 20.0
var cd = 8.0
var animation: AnimatedSprite2D
var target_position = Vector2.ZERO
var coltdown = Timer
var HUD
var coltdown_spell4
var cd_spell4 = 2.0

const orb_kind = MageOrb.OrbKind.RED

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 12.0
		damage_ratio = 0.4
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		
		animation = $Spells_mage_ult
		coltdown_spell4 = service_time.init_timer(self, cd_spell4)
		

func _process(_delta):
	if is_multiplayer_authority() && orb_kind == champion.orb_kind:
		pass

func active():
	self.position = get_global_mouse_position()
	
	self.show()
	animation.frame = 0
	await get_tree().create_timer(0.5).timeout
	
	animation.play()
	await animation.animation_finished
	spell_finished()

func spell_finished():
	for i in range(10):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0).timeout
		
	self.hide()
	self.modulate.a = 1
