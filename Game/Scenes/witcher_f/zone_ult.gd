extends ICollision

var animation: AnimatedSprite2D
var collision

var modulate_bool = false

var duration = 8
var duration_timer: Timer

func _ready():
	if is_multiplayer_authority():
		self.modulate.a = 0.3
		animation = $anim_zone_ult
		collision = $CollisionShape2D # UTILISE PAR LES CUBES S4 ! LAISSER
		duration_timer = service_time.init_timer(self, duration)
			
		await super._ready()

func _process(_delta):
	if is_multiplayer_authority():
		#modulate_bool = ServiceSpell.modulate_obj(self, modulate_bool, 0.2, 0.5)
		pass
		
func active():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 300)
	self.show()
	animation.play()
		
	duration_timer.start()
	animation.stop()