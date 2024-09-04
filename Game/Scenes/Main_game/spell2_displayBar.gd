extends ProgressBar

var coltdown: Timer = Timer.new()

func _ready():
	self.position = Vector2(200, 500)

func _process(_delta):
	self.value = (coltdown.wait_time - coltdown.time_left) / coltdown.wait_time * 100

