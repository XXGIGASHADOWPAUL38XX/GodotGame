extends IPhysicalSpell

var champion
var animation
var passive

var timer_rock_stay: Timer

func after_ready():
	if is_multiplayer_authority():
		champion = ServiceScenes.championNode
		animation = $anim_tank_m_3
		
		await super.after_ready()
		animation.animation_finished.connect(func(obj): collision())
		timer_rock_stay = service_time.init_timer(self, 3)
		timer_rock_stay.timeout.connect(func(): self.hide)

func _process(_delta):
	if is_multiplayer_authority():
		pass
		
func active():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 300)
	self.show()
	animation.play("default")
		
	await animation.animation_finished
	timer_rock_stay.start()
	
	



