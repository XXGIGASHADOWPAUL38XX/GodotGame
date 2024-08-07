extends IActive

var animation

var timer_sphere: Timer
var timer_sphere_duration: float = 4

var timer_missile: Timer
var timer_missile_duration: float = 0.75

var overall_spell

var distance: float = 30.0  # Distance from center_object
var rotation_speed: float = 5  
var current_angle: float:
	get:
		return current_angle
	set(value):
		if value > 2 * PI:
			current_angle = value - (2 * PI)
		current_angle = value

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		animation = $anim_sphere
		overall_spell = self.get_parent()
		
		timer_sphere = service_time.init_timer(self, timer_sphere_duration)
		timer_sphere.timeout.connect(func(): self.hide())
		
		timer_missile = service_time.init_timer(self, timer_missile_duration)
		timer_missile.timeout.connect(Callable(self, 'launch_missile'))
		
		self.visibility_changed.connect(func(): if self.visible: 
			timer_missile.start()
		)
		
		await super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		if self.visible:
			current_angle += rotation_speed * delta
			var direction = Vector2(cos(current_angle), sin(current_angle))
			self.position = champion.position + (direction * distance)

func active():
	self.show()
	timer_sphere.start()

func launch_missile():
	overall_spell.missile.active()
	if timer_sphere.time_left >= timer_missile_duration:
		timer_missile.start()
