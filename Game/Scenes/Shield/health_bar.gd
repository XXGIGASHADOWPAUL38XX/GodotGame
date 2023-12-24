extends ProgressBar

var service_time = preload("res://Game/Services/service_time.gd").new()

var coltdown_wave = Timer.new()
var cd_wave
var health_bar

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar = get_parent()
	self.size = 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		self.position = Vector2(
			health_bar.position.x + (health_bar.value * (health_bar.size.x / health_bar.max_value)),
			health_bar.position.y
		)
		
func set_value(value, time):
	if is_multiplayer_authority():
		coltdown_wave = service_time.init_timer(self, cd_wave)
		ServiceScenes.championNode.add_func_hitted(Callable(special))
