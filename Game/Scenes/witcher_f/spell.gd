extends IDamagingSpell

var collision_shape
var base_size
var base_scale

func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 9.0
		damage_ratio = 0.25
		# ------------------------------------ #
		
		collision_shape = $CollisionShape2D
		
		animation.animation = 'pre'
		COLLISION_ON_SPECIFIC_ANIM = true
		
		base_scale = self.scale.x
		base_size = collision_shape.shape.height
		
		await super.after_ready()

func _process(delta):
	if is_multiplayer_authority():
		pass
			
func active(cube, active_cube):
	self.position = (cube.position + active_cube.position) / 2
	self.rotation = (active_cube.position - cube.position).angle()
	self.scale.x = (cube.position.distance_to(active_cube.position) / base_size)
	
	#self.modulate.a = 0
	self.show()
	
	await get_tree().create_timer(0.4).timeout
	animation.animation = 'damage'
	
	animation.play()
	
	for i in range(10):
		#self_modulate.a += 0.1
		await get_tree().create_timer(0).timeout
		
	await get_tree().create_timer(0.1).timeout
	
	for i in range(10):
		#self_modulate.a -= 0.1
		await get_tree().create_timer(0).timeout
		
	self.hide()
