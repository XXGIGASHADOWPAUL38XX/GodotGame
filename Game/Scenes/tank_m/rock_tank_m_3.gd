extends IPhysicalSpell

var passive

var timer_rock_stay: Timer

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IPHYSICALSPELL #
		damage_base = 5.0
		# ------------------------------------ #
		await super._ready()
		timer_rock_stay = service_time.init_timer(self, 3)
		timer_rock_stay.timeout.connect(disappear)

func _process(_delta):
	if is_multiplayer_authority():
		pass
		
func active():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 300)
	self.show()
	animation.play("default")
		
	await animation.animation_finished
	timer_rock_stay.start()
	
func disappear():
	for i in range(10):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.01).timeout
		
	self.hide()
	self.modulate.a = 1
	


