extends IControllerKeyPressed

var first_activation = true
var zone_timer: Timer

var zone
var jump
var anim_champ_leap
var champion

func _ready():
	if is_multiplayer_authority():
		key = KEY_A
		coltdown_time = 6
		
		champion = ServiceScenes.championNode
		zone = $zone
		jump = $jump
		anim_champ_leap = $anim_champ_leap
		
		zone_timer = service_time.init_timer(self, 2)
		zone_timer.timeout.connect(func(): 
			if first_activation:
				first_activation = false
				active()
		)
		
		await super._ready()

func active():
	super.active()
	if first_activation:
		champion.add_state(self, 'states_action', State.StateAction.IMMOBILE)
		zone.active()
		anim_champ_leap.active()
		champion.leap()
		
		zone_timer.start()
		return 
		
	
	zone.end_spell()
	await jump.active()
	champion.remove_state(self, 'states_action')
	
	first_activation = true
