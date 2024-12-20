extends Camera2D

var DIFFERENCE_X_OFFSET
var DIFFERENCE_Y_OFFSET
const RATIO = 0.9

const S_MIN_DENUM = 110
var sensibility = 50

func _ready():
	DIFFERENCE_X_OFFSET = ServiceWindow.scene_size.x / 2 * RATIO * (get_window().size.x / ServiceWindow.scene_size.x)
	DIFFERENCE_Y_OFFSET = ServiceWindow.scene_size.y / 2 * RATIO * (get_window().size.y / ServiceWindow.scene_size.y)
	
	self.offset = Vector2(ServiceWindow.scene_size.x / 2, ServiceWindow.scene_size.y / 2)
	ServiceScenes.camera = self
	
	sensibility = ServiceScenes.settings_scene.camera_ssiblty_slider.value
	
	ServiceScenes.settings_scene.camera_ssiblty_slider.drag_ended.connect(func(value): 
		sensibility = ServiceScenes.settings_scene.camera_ssiblty_slider.value
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var difference_x = get_global_mouse_position().x - self.offset.x
	var difference_y = get_global_mouse_position().y - self.offset.y
	
	if (difference_x > DIFFERENCE_X_OFFSET && self.offset.x < ServiceWindow.scene_size.x):
		self.offset.x += difference_x / (S_MIN_DENUM - sensibility)
	elif (-1 * difference_x > DIFFERENCE_X_OFFSET && self.offset.x > 0):
		self.offset.x += difference_x / (S_MIN_DENUM - sensibility)
	
	if (difference_y > DIFFERENCE_Y_OFFSET && self.offset.y < ServiceWindow.scene_size.y):
		self.offset.y += difference_y / (S_MIN_DENUM - sensibility)
	elif (-1 * difference_y > DIFFERENCE_Y_OFFSET && self.offset.y > 0):
		self.offset.y += difference_y / (S_MIN_DENUM - sensibility)
		
func _input(event):
	if event is InputEventMouseButton && false:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			self.zoom += Vector2(0.05, 0.05) 
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			self.zoom -= Vector2(0.05, 0.05) 
