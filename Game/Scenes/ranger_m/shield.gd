extends ProgressBar

var service_time = ServiceTime.new()

var coltdown = Timer.new()
var health_bar

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar = get_parent().get_node('health_bar')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority(): 
		if self.size.x > 4:
			if self.visible == false:
				self.show()
				
			self.position = Vector2(
				health_bar.size.x * (health_bar.value / health_bar.max_value) / 2,
				-35
			)
		else:
			self.hide()
		
func set_shield(value_shield, time):
	if is_multiplayer_authority():
		coltdown = service_time.init_timer(self, time)
		coltdown.timeout.connect(shield_expired)
		coltdown.start()
		self.size.x = value_shield * (health_bar.size.x / health_bar.max_value) + 4

func set_value(value_shield):
	if is_multiplayer_authority():
		self.size.x = value_shield * (health_bar.size.x / health_bar.max_value) + 4

func shield_expired():
	self.size.x = 4
