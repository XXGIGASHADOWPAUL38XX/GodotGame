extends IDamagingSpell

var speed = 20.0
var animation: AnimatedSprite2D

func _ready():	
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 9.0
		damage_ratio = 0.2
		# ------------------------------------ #
		
		await super._ready()
		
		animation = $anim_jump as AnimatedSprite2D

func _process(_delta):
	if is_multiplayer_authority():
		pass
		
func active():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), spell_controller.zone.get_radius())
	champion.position = self.position
	self.show()
	animation.play()

	for i in range(20):
		self.modulate.a -= 0.05
		await get_tree().create_timer(0.01).timeout 
		
	animation.stop()
	self.hide()
	self.modulate.a = 1
