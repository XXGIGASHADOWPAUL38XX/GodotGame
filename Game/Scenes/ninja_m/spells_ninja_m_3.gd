extends IDamagingSpell

var speed = 20.0
var throw_direction = Vector2.RIGHT
var shadow_assigned

var animation

func _ready():	
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 4.0
		damage_ratio = 0.125
		# ------------------------------------ #
		
		animation = $anim_ninja_m_3
		
		await super._ready()
		
		self.hide()

func _process(_delta):
	if is_multiplayer_authority():
		pass

func active(main_vector):
	if !shadow_assigned.is_active():
		return
	
	self.position = shadow_assigned.position + (main_vector / 2) 
	self.show()
	
	self.rotation = main_vector.angle()
	animation.play()

	await animation.animation_finished
	
	self.hide()
	shadow_assigned.position += main_vector

func post_dp_script(id, nbr_dupl):
	await await_resource_loaded(func(): return self.spells_placeholder != null && spells_placeholder.shadows.size() == 4)
	
	shadow_assigned = spells_placeholder.shadows[id - 1]
	
