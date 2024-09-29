extends IControllerKeyPressed

var spell_zone
var champion

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_ultimate']
		coltdown_time = 11
		spell_zone = $zone_warrior_m_4
		
		cast_time = 0.1
		cast_kind = CastTime.Kind.BeforeActive
		
		champion = ServiceScenes.championNode
		
		await super._ready()
		
func active():
	var hits = $dp_hit_warrior_m_4.get_children().filter(
		func(obj): return obj is IDamagingCollision
	)
	if hits.size() > 1:
		coltdown.start()
		spell_zone.active()
		await hits.map(func(hit): await hit.active())
