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
		slice_distance = collision_shape.polygon[0].distance_to(collision_shape.polygon[2]) * self.scale.x
		
		await super._ready()

func active():
	self.position = ServiceSpell.set_in_front_mouse(ServiceScenes.championNode, get_global_mouse_position(), 50)
	animation.play()

	self.rotation = ServiceSpell.set_in_front_mouse(ServiceScenes.championNode, get_global_mouse_position(), 30).angle()
	
	self.show()
	
	await animation.animation_finished
	ServiceScenes.championNode.position += ServiceSpell.set_in_front_mouse(
		ServiceScenes.championNode, get_global_mouse_position(), slice_distance
	)

	self.hide()
	animation.stop()

