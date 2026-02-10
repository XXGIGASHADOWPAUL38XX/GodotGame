extends IActive

func _ready():
	if is_multiplayer_authority():
		await super._ready()
		
		self.hide()
		animation = $dash_ranger_anim_2 as AnimatedSprite2D
		animation.animation_finished.connect(end_dash)
		animation.frame_changed.connect(func(): 
			if animation.frame == ceil(animation.sprite_frames.get_frame_count(animation.animation) / 2):
				champion_move()
		)

func active():
	if is_multiplayer_authority():
		champion.hide()
		self.position = champion.position
		
		self.show()
		animation.play("spell2_dash")
		
		#await get_tree().create_timer(0.1).timeout
		
func end_dash():
	self.hide()
	self.position = champion.position
	champion.show()
	
func champion_move():
	champion.position += ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 90)
