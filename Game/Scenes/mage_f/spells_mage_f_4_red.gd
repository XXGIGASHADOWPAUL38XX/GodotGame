extends IDamagingSpell

var speed = 20.0
var cd = 8.0
var target_position = Vector2.ZERO
var coltdown = Timer

const orb_kind = MageOrb.OrbKind.RED

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 12.0
		damage_ratio = 0.4
		COLLISION_ON_SPECIFIC_ANIM = true
		# ------------------------------------ #
		
		await super._ready()
		animation.animation = 'pre'
		
		self.hide()

func active():
	self.position = get_global_mouse_position()
	
	self.show()
	await get_tree().create_timer(spell_controller.cast_time).timeout

	animation.animation = 'damage'
	animation.play()
	
	await animation.animation_finished
	spell_finished()

func spell_finished():
	for i in range(10):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0).timeout
		
	self.hide()
	self.modulate.a = 1
	animation.animation = 'pre'
	
