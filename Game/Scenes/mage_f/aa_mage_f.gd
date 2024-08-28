extends IDamagingSpell

var speed = 12.0
var throw_direction = Vector2.RIGHT

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 4.0
		damage_ratio = 0.1
		# ------------------------------------ #
		
		await super._ready()

func _process(delta):
	if is_multiplayer_authority():
		pass
			
func active():
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 30)
	
	var direction = (get_global_mouse_position() - champion.position).normalized()
	self.rotation = direction.angle()

	self.show()
	animation.play()
	
	for i in range(13):
		self.position += (direction) * speed
		await get_tree().create_timer(0).timeout
		
	self.hide()
		

