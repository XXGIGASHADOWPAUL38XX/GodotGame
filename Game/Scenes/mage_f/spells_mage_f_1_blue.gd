extends IDamagingSpell

var speed = 16.0
var throw_direction = Vector2.RIGHT
var animation 

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 9.0
		damage_ratio = 0.25
		# ------------------------------------ #
		
		animation = $Spells_mage_anim
		
		await super._ready()

func _process(delta):
	if is_multiplayer_authority():
		pass
			
func active():
	animation.frame = 0
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 30)
	
	var direction = get_global_mouse_position() - position
	direction = direction.normalized()

	self.show()
	animation.play()
	for i in range(12):
		self.position += direction * speed
		await get_tree().create_timer(0).timeout

