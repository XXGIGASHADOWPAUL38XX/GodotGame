extends ProgressBar

var coltdown: Timer = Timer.new()

func _ready():
	pass

func _process(_delta):
	self.value = (coltdown.wait_time - coltdown.time_left) / coltdown.wait_time * 100

func bindTo(inputTimer):
	coltdown = inputTimer
