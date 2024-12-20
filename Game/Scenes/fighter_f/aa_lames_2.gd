extends IDamagingSpell



# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 2.5
		damage_ratio = 0.04
		# ------------------------------------ #
		
		await super._ready()
		self.hide()
		
		animation = $aa_anim

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active():
	self.position = champion.position + ServiceSpell.set_in_front_mouse_incl(self, get_global_mouse_position(), 30, -30)
	self.rotation = (get_global_mouse_position() - champion.position).angle()
	
	self.show()
	animation.play()
	await animation.animation_finished
	
	self.hide()
