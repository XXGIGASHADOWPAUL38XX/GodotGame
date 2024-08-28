class_name IHoldableCounter

extends ICounter

var cd_spell
var spell: AnimatedSprite2D
var coltdown_spell: Timer
var HUD
var key

var timer_key_release_cd
var timer_key_release = Timer.new()
var key_released_bool = false

func after_ready():
	if is_multiplayer_authority():
		await super.after_ready()

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(key):
			if coltdown_spell.time_left == 0:
				timer_key_release = service_time.init_timer(self, timer_key_release_cd)
				timer_key_release.timeout.connect(stop_spell)
				timer_key_release.start()
				key_released_bool = true
				
				coltdown_spell.start()
				start_spell()
		elif key_released_bool == true:
			stop_spell()

func start_spell():
	pass

func stop_spell():
	timer_key_release.timeout.disconnect(stop_spell)
	key_released_bool = false


