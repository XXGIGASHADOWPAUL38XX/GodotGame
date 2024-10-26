extends Control

var service_time = ServiceTime.new()
var current_loadings: Dictionary = {}
var resource_awaiter = ResourceAwaiter.new()

var label_loading_base_text = "Loading"
var dots_after_label_loading: int = 0:
	get:
		return dots_after_label_loading
	set(value):
		dots_after_label_loading = value % 4
		
var timer_increment_dot: Timer
var delay_increment_dot: float = 0.2

@onready var label_loading = $CenterContainer/label_loading
@onready var label_resource_loading = $CenterContainer/MarginContainer/resource_loading

# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.loading_async = self
	
	timer_increment_dot = service_time.init_timer(self, delay_increment_dot)
	
	timer_increment_dot.timeout.connect(func():
		dots_after_label_loading += 1
		label_loading.text = label_loading_base_text + ".".repeat(dots_after_label_loading)
		timer_increment_dot.start()
	)
	
	self.visibility_changed.connect(func(): 
		if self.visible:
			ServiceScenes.root_scene.move_child(self, ServiceScenes.root_scene.get_child_count() - 1)
			dots_after_label_loading = 1
			timer_increment_dot.start()
			ServiceScenes.root_scene.get_children().filter(func(scene): return scene != self).map(func(scene):
				scene.modulate = Color.DIM_GRAY
			)
		else:
			ServiceScenes.root_scene.get_children().filter(func(scene): return scene != self).map(func(scene):
				scene.modulate = Color.WHITE
			)
	)

func add_loading(key, resource_loading=null):
	if resource_loading != null && label_resource_loading.text == '':
		label_resource_loading.text = resource_loading
		
	current_loadings[key] = resource_loading
	if !self.visible:
		self.show()
		
	get_parent().move_child(self, get_parent().get_child_count() - 1)
	
func remove_loading(key):
	current_loadings.erase(key)
	if current_loadings.values().size() == 0:
		self.hide()
	else:
		label_resource_loading.text = current_loadings.values()[0]

func check_if_loading(scene_child):
	if current_loadings.values().size() != 0:
		scene_child.modulate = Color.DIM_GRAY
