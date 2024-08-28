extends Control

var camera
var service_time = preload("res://Game/Services/service_time.gd").new()
var timer = Timer.new()
signal anncounce_timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera == null:
		camera = ServiceScenes.getCamera()
	else:
		self.position = camera.offset

	if $Panel/HBox/Time.text != '' && $Panel/HBox/Time.text != '0':
		$Panel/Progress.max_value = timer.wait_time
		$Panel/Progress.value = timer.time_left
		#$Panel/HBox/Time.text = str(ceil(timer.time_left))
	
func set_announce(announce, time, relative=false, time_implicit=false): #RELATIVE = RELATIVE TO ONE SPECIFIC PLAYER 
	timer = service_time.init_timer(self, time)
	timer.start()
	timer.timeout.connect(func():
		hide_announcer()
	)
	$Panel.play("default")
	
	$Panel/HBox/Announce.text = announce + ' '
	$Panel/HBox/Time.text = str(time)
	
	show_announcer()

func show_announcer():
	$Panel.modulate.a = 0
	self.show()
	
	for i in range(10):
		$Panel.modulate.a += 0.1
		await get_tree().create_timer(0).timeout

func hide_announcer():
	emit_signal('anncounce_timeout')
		
	self.hide()
