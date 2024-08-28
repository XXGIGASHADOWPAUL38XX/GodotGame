extends IDamagingSpell

var speed = 20.0
var cd_spell2 = 0.01
var spell2: AnimatedSprite2D
var coltdown_spell2: Timer
var HUD

var shadow_node
var shadow_to_dash
var collision_shape: CollisionPolygon2D

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 9.0
		damage_ratio = 0.25
		# ------------------------------------ #
		
		await super._ready()
		animation = $anim_ninja_m_2

func _process(_delta):
	if is_multiplayer_authority():
		pass

func active():
	if is_multiplayer_authority():
		var endpoint_dash = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 100)
		
		self.position = champion.position + ((endpoint_dash - champion.position) / 2)
		self.rotation = (endpoint_dash - champion.position).angle()
		self.show()
		
		#animation.scale.x = animation.scale.x * champion.position.distance_to(
			#shadow_to_dash.global_position) / 200
			
		animation.play("default")
		
		champion.position = endpoint_dash
			
		await animation.animation_finished
		
		self.hide()
		animation.scale.x = 0.2

