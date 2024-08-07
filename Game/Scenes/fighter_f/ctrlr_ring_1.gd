extends IControllerSpell

var first_activation = true
var zone_timer: Timer

var zone
var jump
var anim_champ_leap
var champion

func _ready():
	if is_multiplayer_authority():
		key = KEY_A
		coltdown_time = 5
		
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
	if first_activation:
		champion.state_movement = State.StateMovement.IMMOBILE
		zone.active()
		anim_champ_leap.active()
		champion.leap()
		
		zone_timer.start()
		return 
		
	coltdown.start()
	zone.end_spell()
	await jump.active()
	champion.state_movement = State.StateMovement.NULL
	
	first_activation = true
