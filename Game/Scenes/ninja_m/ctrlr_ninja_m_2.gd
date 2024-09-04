extends IControllerKeyPressed

var dash
var ennemies_marked: Array:
	get:
		return ennemies_marked

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_2']
		coltdown_time = 6
		cast_time = ServiceSpell.animation_duration($dash/anim_ninja_m_2)
		
		dash = $dash as IDamagingSpell
		dash.CONF_DETECT_WITH = ServiceScenes.allEnnemiesNode
		ennemies_marked = ServiceScenes.allEnnemiesNode
		
		await super._ready()
		
		dash.area_entered.connect(func(area): 
			if area in spells_placeholder.shadows:
				reset()
				area.has_been_dashed_to()
				spells_placeholder.marks.map(func(mark):
					mark.show_on_shadow_entered()
				)
			elif area in spells_placeholder.marks:
				reset()
				area.hide_on_dash()
		)

func active():
	await super.active()
	dash.active()

func reset(is_champion=false):
	if is_champion:
		if !(dash.player_hitted in ennemies_marked):
			return
		ennemies_marked.remove_at(ennemies_marked.find(dash.player_hitted))
		timer_set_mark_entity(dash.player_hitted)
	
	coltdown.stop()
	coltdown.emit_signal("timeout")

func timer_set_mark_entity(entity):
	var timer_set_mark = service_time.init_timer(self, 5)
	timer_set_mark.timeout.connect(func(): 
		ennemies_marked.append(entity)
		timer_set_mark.queue_free()
	)
	timer_set_mark.start()
