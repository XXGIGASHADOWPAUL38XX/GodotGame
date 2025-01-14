extends IDamagingSpell

var modulate_bool = false

var duration = 3
var duration_timer: Timer
var hit_instance = 0

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 4.0
		damage_ratio = 0.1
		
		retrigger = true
		retrigger_time = 0.75
		
		self.visibility_changed.connect(func(): hit_instance = 0)
		func_on_collision.append(func(): hit_instance += 1)
		# ------------------------------------ #
		
		duration_timer = service_time.init_timer(self, duration)
		
		await super._ready()

func _process(_delta):
	if is_multiplayer_authority():
		modulate_bool = ServiceSpell.modulate_obj(self, modulate_bool, 0.3, 0.7)
		pass
		
func active():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 300)
	self.show()
	animation.play()
		
	duration_timer.start()
	await duration_timer.timeout
	
	animation.stop()
	self.hide()
