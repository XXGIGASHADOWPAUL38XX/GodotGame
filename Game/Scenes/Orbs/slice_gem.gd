extends IDamagingCollision

var coltdown = Timer.new()
var cd = 15.0

var animation
var collision_shape
var slice_distance

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 5.0
		damage_ratio = 0.0
		# ------------------------------------ #
		
		coltdown = service_time.init_timer(self, cd)
		animation = $animation_dash
		collision_shape = $CollisionShape2D
		slice_distance = collision_shape.shape.polygon[0].collision_shape.shape.polygon[2]
		
		await super._ready()

func active():
	self.position = ServiceSpell.set_in_front_mouse(ServiceScenes.championNode, get_global_mouse_position(), 50)
	animation.play('default')

	self.rotation = ServiceSpell.set_in_front_mouse(ServiceScenes.championNode, get_global_mouse_position(), 30).angle()
	ServiceScenes.championNode.set_attribute('speed', 0, 0.2)
	
	self.show()
	
	await get_tree().create_timer(0.15).timeout
	ServiceScenes.championNode.position += ServiceSpell.set_in_front_mouse(
		ServiceScenes.championNode, get_global_mouse_position(), slice_distance)
	
	await get_tree().create_timer(0.2).timeout
	self.hide()
	animation.stop()

