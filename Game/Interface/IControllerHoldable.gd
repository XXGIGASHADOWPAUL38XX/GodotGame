extends IControllerKeyPressed

class_name IControllerHoldable

var timer_key_release_cd
var timer_key_release = Timer.new()
var key_released_bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		super._ready()

func _input(event):
	if is_multiplayer_authority() && event is InputEventKey && event.scancode == key:
		if event.is_pressed():
			can_active()
		elif event.is_released() && timer_key_release.time_left != 0:
			stop_spell()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if is_multiplayer_authority() && cond_spells.all(func(c: Callable): return c.call()):
		#if Input.is_key_pressed(key):
			#if coltdown.time_left == 0:
				#timer_key_release = service_time.init_timer(self, timer_key_release_cd)
				#timer_key_release.timeout.connect(stop_spell)
				#timer_key_release.start()
				#key_released_bool = true
				#
				#coltdown.start()
				#self.active()
				#
		#elif key_released_bool == true:
			#stop_spell()

func can_active():
	if cond_spells.all(func(c: Callable): return c.call()):
		timer_key_release = service_time.init_timer(self, timer_key_release_cd)
		timer_key_release.timeout.connect(stop_spell)
		timer_key_release.start()
		key_released_bool = true
		
		coltdown.start()
		self.active()

func active():
	pass

func stop_spell():
	if timer_key_release.timeout.is_connected(stop_spell):
		timer_key_release.timeout.disconnect(stop_spell)
	
	key_released_bool = false
