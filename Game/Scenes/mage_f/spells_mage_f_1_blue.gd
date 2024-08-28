extends IDamagingSpell

var speed = 16.0
var throw_direction = Vector2.RIGHT 

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 9.0
		damage_ratio = 0.25
		# ------------------------------------ #
		
			
		await super._ready()

func _process(delta):
	if is_multiplayer_authority():
		pass
		
func active():
	self.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 30)
	
	var base_destination = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 300)
	var base_direction = get_global_mouse_position() - champion.position
	self.rotation = base_direction.angle()

	self.show()
	animation.play()
	
	while (self.position.distance_to(base_destination) >= (speed / 2)):
		var current_distance_to_dstn = self.position.distance_to(base_destination)
		self.position += base_direction.normalized() * speed
		await get_tree().create_timer(0).timeout

