extends IDamagingSpell

var throw_direction = Vector2.RIGHT
var passive: CharacterBody2D
var HUD
var shadow_node

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 10.0
		damage_ratio = 0.3
		# ------------------------------------ #
		
		await super._ready()
		
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
