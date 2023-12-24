extends "res://Game/Interface/IDamagingSpell.gd"

var champion
var throw_direction = Vector2.RIGHT
var cd_spell1 = 5.0
var animation: AnimatedSprite2D
var coltdown_spell1: Timer
var passive: CharacterBody2D
var HUD
var shadow_node

func _ready():	
	if is_multiplayer_authority():
		super._ready()
		champion = ServiceScenes.championNode
		animation = $anim_ninja_m_1
		shadow_node = get_parent().get_node('animations').get_node('shadow')
		
		coltdown_spell1 = service_time.init_timer(self, cd_spell1)

func _process(delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_A) && coltdown_spell1.time_left == 0:
			coltdown_spell1.start()
			spell1_mark('shadow_a')
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell1, 1)

func spell1_mark(shadow_name):
	var speed = 15.0
	self.position = champion.position + ServiceSpell.set_in_front_mouse(
		champion, get_global_mouse_position(), 30)
	
	var direction = get_global_mouse_position() - position
	self.rotation = direction.angle()

	self.show()
	for i in range(12):
		self.position += (direction.normalized() * speed)
		await get_tree().create_timer(0).timeout

	self.hide()
	Servrpc.any(shadow_node, 'duplicate_shadow', [shadow_name, self.global_position, 300])
