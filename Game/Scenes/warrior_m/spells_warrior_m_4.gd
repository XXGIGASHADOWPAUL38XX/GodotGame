extends IControllerKeyPressed

var spell_zone
var champion

func _ready():
	if is_multiplayer_authority():
		key = KEY_SPACE
		coltdown_time = 11
		spell_zone = $zone_warrior_m_4
		
		champion = ServiceScenes.championNode
		
		await super._ready()
		
func active():
	var hits = $dp_hit_warrior_m_4.get_children().filter(
		func(obj): return obj is IDamagingCollision
	)
	if hits.size() > 1:
		coltdown.start()
		spell_zone.active()
		champion.add_state(self, 'states_movement', State.StateMovement.IMMOBILE)
		await hits.map(func(hit): await hit.active())
		
		champion.remove_state(self, 'states_movement')
