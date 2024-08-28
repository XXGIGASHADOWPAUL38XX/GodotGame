extends IControllerKeyPressed

var dash_first
var dash_back
var anim_dash

var first_activation: bool = true

var timer_visible
var timer_visible_cd = 3

func after_ready():
	if is_multiplayer_authority():
		key = KEY_E
		coltdown_time = 6
		cast_time = 0.25
		
		dash_first = $dash_first
		dash_back = $dash_back
		anim_dash = $anim_dash
		
		timer_visible = service_time.init_timer(self, timer_visible_cd)
		timer_visible.timeout.connect(func(): 
			first_activation = true
			dash_first.hide()
			dash_back.hide()
		)
		
		await super.after_ready()

func active():
	super.active()
	if first_activation:
		dash_first.can_active_first()
		dash_back.can_active_first()
		first_activation = false
		timer_visible.start()
	
	else:
		dash_first.can_active_back()
		dash_back.can_active_back()
		
		
	anim_dash.can_active()
	pass
