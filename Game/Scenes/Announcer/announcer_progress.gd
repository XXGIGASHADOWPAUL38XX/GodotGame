extends Control

var camera
var service_time = ServiceTime.new()
var timer = Timer.new()
signal anncounce_timeout

@onready var display_time = $Panel/CenterContainer/HBox/Time
@onready var announcer = $Panel/CenterContainer/HBox/Announce
@onready var progress = $Panel/Progress
@onready var panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera == null:
		camera = ServiceScenes.camera
	else:
		self.position = camera.offset

	if display_time.text != '' && display_time.text != '0':
		progress.max_value = timer.wait_time
		progress.value = timer.time_left
		#time.text = str(ceil(timer.time_left))
	
func set_announce(announce, time, relative=false, time_implicit=false): #RELATIVE = RELATIVE TO ONE SPECIFIC PLAYER 
	if timer.timeout.is_connected(hide_announcer):
		timer.timeout.disconnect(hide_announcer)
	
	timer = service_time.init_timer(self, time)
	timer.start()
	timer.timeout.connect(hide_announcer)
	panel.play("default")
	
	announcer.text = announce + ' '
	display_time.text = str(time)
	
	show_announcer()

func show_announcer():
	panel.modulate.a = 0
	self.show()
	
	for i in range(10):
		panel.modulate.a += 0.1
		await get_tree().create_timer(0).timeout

func hide_announcer():
	emit_signal('anncounce_timeout')
	self.hide()
