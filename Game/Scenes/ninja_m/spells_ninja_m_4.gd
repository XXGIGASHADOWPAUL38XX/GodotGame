extends "res://Game/Interface/IDamagingSpell.gd"

var champion
var throw_direction = Vector2.RIGHT
var animation: AnimatedSprite2D
var passive: CharacterBody2D
var HUD
var shadow_node

func _ready():	
	champion = ServiceScenes.championNode
	animation = $anim_ninja_m_1
	shadow_node = get_parent().get_node('animations').get_node('shadow')

func _process(delta):
	pass

func spell4_mark(shadow_name, rotation):
	var speed = 10.0
	self.position = champion.position + ServiceSpell.set_in_front_mouse(
		champion, get_global_mouse_position(), 30)
	var direction = (get_global_mouse_position() - self.global_position)
	direction = direction.rotated(deg_to_rad(rotation))
	
	self.rotation = direction.angle()

	animation.play("default")
	self.show()
	for i in range(12):
		self.position += direction.normalized() * speed
		await get_tree().create_timer(0).timeout
	self.hide()
	Servrpc.any(shadow_node, 'duplicate_shadow', [shadow_name, self.global_position, 300])
	
	animation.stop()
