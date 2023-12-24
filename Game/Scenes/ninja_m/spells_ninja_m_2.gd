extends "res://Game/Interface/IDamagingSpell.gd"

var speed = 20.0
var champion
var cd_spell2 = 0.01
var spell2: AnimatedSprite2D
var coltdown_spell2: Timer
var HUD
var animation
var shadow_node
var shadow_to_dash
var collision_shape: CollisionPolygon2D

func _ready():
	if is_multiplayer_authority():
		super._ready()
		champion = ServiceScenes.championNode
		shadow_node = get_parent().get_node('animations').get_node('shadow')
		coltdown_spell2 = service_time.init_timer(self, cd_spell2)
		animation = $anim_ninja_m_2
		collision_shape = $CollisionPolygon2D

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_Z) && coltdown_spell2.time_left == 0:
			coltdown_spell2.start()
			spell2_check_shadow()
		
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell2, 2)

func spell2_check_shadow():
	shadow_to_dash = shadow_node.get_shadow_clicked(get_global_mouse_position())
	if shadow_to_dash != null:
		spell2_dash(shadow_to_dash)

func spell2_dash(shadow_to_dash):
	if is_multiplayer_authority():
		champion.set_attribute('state_damage', State.StateMovement.IMMOBILE)
		
		self.show()
		self.position = (champion.position + shadow_to_dash.global_position) / 2
		self.rotation = (self.position - champion.position).angle()
		animation.scale.x = animation.scale.x * champion.position.distance_to(
			shadow_to_dash.global_position) / 200
			
		animation.play("default")
		
		champion.position = shadow_to_dash.global_position
		Servrpc.any(shadow_to_dash, 'expire', []) 
			
		champion.set_attribute('state_movement', State.StateMovement.IMMOBILE)
		
		await get_tree().create_timer(0.15).timeout
		animation.stop()
		self.hide()
		animation.scale.x = 0.2

