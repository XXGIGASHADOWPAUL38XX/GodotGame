extends IControllerHoldable

var counter_count
var anim_rotate
var reduce
var zone_damage

var timer_active: Timer
var timer_active_duration: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_2']
		coltdown_time = 7
		timer_key_release_cd = 0.75
		
		counter_count = $counter_count
		anim_rotate = $anim_rotate
		reduce = $reduce
		zone_damage = $zone_damage
		
		timer_active = service_time.init_timer(self, timer_active_duration)
		
		await super._ready()

func active():
	await super.active()
	counter_count.show()
	anim_rotate.show()
	reduce.show()
	reduce.active()
	
	timer_active.start()
	
	await timer_active.timeout
	
	counter_count.hide()
	anim_rotate.hide()
	reduce.hide()

	zone_damage.active()

func stop_spell():
	super.stop_spell()

