extends IControllerKeyPressed

var first_activation = true

var zone_timer: Timer
var zone_duration = 1

var zone
var jump
var anim_champ_leap
var champion

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_1']
		coltdown_time = 6
		cast_time = zone_duration
		
		champion = ServiceScenes.championNode
		zone = $zone
		jump = $jump
		anim_champ_leap = $anim_champ_leap
		
		zone_timer = service_time.init_timer(self, zone_duration)
		zone_timer.timeout.connect(func(): 
			first_activation = false
			active()
		)
		
		await super._ready()

func active():
	await super.active()
	if first_activation:
		zone.active()
		anim_champ_leap.leap()
		
		zone_timer.start()
		return 
		
	anim_champ_leap.fall_back()
	await jump.active()
	zone.end_spell()
	
	first_activation = true
