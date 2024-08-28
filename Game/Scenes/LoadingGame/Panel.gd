extends Panel

var service_time = preload("res://Game/Services/service_time.gd").new()

var label_loading_base_text = "Loading"
var dots_after_label_loading: int = 0:
	get:
		return dots_after_label_loading
	set(value):
		dots_after_label_loading = value % 4
		
var timer_increment_dot: Timer
var delay_increment_dot: float = 0.4

var actives = []
var last_active_loaded = 'null'
var loaded_actives: Array = []:
	get:
		if loaded_actives.size() != 0:
			last_active_loaded = loaded_actives[loaded_actives.size() - 1].name
		return loaded_actives

@onready var loading_bar = $loading_bar
@onready var label_loading = $label_loading
@onready var current_resource = $current_resource

# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.loading_game = self
	timer_increment_dot = service_time.init_timer(self, delay_increment_dot)
	
	timer_increment_dot.timeout.connect(func():
		dots_after_label_loading += 1
		label_loading.text = label_loading_base_text + ".".repeat(dots_after_label_loading)
		timer_increment_dot.start()
	)
	
	self.visibility_changed.connect(func(): 
		if self.visible:
			timer_increment_dot.start()
		else:
			pass
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(randf())
	if self.visible:
		current_resource.text = "loaded : " + last_active_loaded
		loading_bar.max_value = actives.size()
		loading_bar.value = loaded_actives.size()
		
		

