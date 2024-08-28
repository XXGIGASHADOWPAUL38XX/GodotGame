extends IControllerKeyPressed

var spell_zone
var champion

func after_ready():
	if is_multiplayer_authority():
		key = KEY_SPACE
		coltdown_time = 11
		spell_zone = $zone_warrior_m_4
		
		champion = ServiceScenes.championNode
		
		await super.after_ready()
		
func active():
	var hits = $dp_hit_warrior_m_4.get_children().filter(
		func(obj): return obj is IDamagingCollision
	)
	if hits.size() > 1:
		coltdown.start()
		spell_zone.can_active()
		await hits.map(func(hit): await hit.can_active())

