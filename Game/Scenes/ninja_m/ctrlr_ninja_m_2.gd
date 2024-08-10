extends IControllerKeyPressed

var dash
var ennemies_marked: Array:
	get:
		return ennemies_marked

func _ready():
	if is_multiplayer_authority():
		key = KEY_Z
		coltdown_time = 6
		
		dash = $dash as IDamagingSpell
		dash.CONF_DETECT_WITH = ServiceScenes.allEnnemiesNode
		ennemies_marked = ServiceScenes.allEnnemiesNode
		
		await super._ready()
		
		dash.func_on_entity_entered.append(Callable(self, 'reset').bind(true))
		dash.area_entered.connect(func(area): if area in spells_placeholder.shadows:
			reset()
			area.has_been_dashed_to()
		)

func active():
	dash.active()
	coltdown.start()

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
