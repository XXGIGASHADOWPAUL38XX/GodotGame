extends IDamagingSpell



# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6
		damage_ratio = 0.115
		# ------------------------------------ #
		
		await super.after_ready()
		self.hide()
		
		animation = $aa_anim

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active():
	self.position = champion.position
	self.rotation = (get_global_mouse_position() - champion.position).angle()
	self.show()
	animation.play()
	
	for i in range(12):
		self.rotate(deg_to_rad(30))
		await get_tree().create_timer(0).timeout
	
	self.hide()
