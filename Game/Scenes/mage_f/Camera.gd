extends Camera2D

const RATIO = 0.25
const BORDER_WIDTH = 500
const WIDTH_MAX = 900
const HEIGHT_MAX = 600
const SENSIBILITY = 2

func _ready():
	self.offset = Vector2(get_window().size.x / 2, get_window().size.y / 2)
	ServiceScenes.camera = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var difference_x = get_global_mouse_position().x - self.offset.x
	var difference_y = get_global_mouse_position().y - self.offset.y
	
	if (difference_x > BORDER_WIDTH && self.offset.x - get_window().size.x < WIDTH_MAX):
		self.offset.x += difference_x / 60
	elif (-1 * difference_x > BORDER_WIDTH && -1 * (self.offset.x - get_window().size.x) < WIDTH_MAX):
		self.offset.x += difference_x / 60
	
	if (difference_y > BORDER_WIDTH && self.offset.y - get_window().size.y < HEIGHT_MAX):
		self.offset.y += difference_y / 60
	elif (-1 * difference_y > BORDER_WIDTH && -1 * (self.offset.y - get_window().size.y) < HEIGHT_MAX):
		self.offset.y += difference_y / 60
		
func _input(event):
	if event is InputEventMouseButton && true == false:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			self.zoom += Vector2(0.05, 0.05) 
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			self.zoom -= Vector2(0.05, 0.05) 
