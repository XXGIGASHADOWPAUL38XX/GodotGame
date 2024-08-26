extends IActive

var animation

func _ready():
	if is_multiplayer_authority():
		await super._ready()
		self.hide()
		animation = $dash_ranger_anim_2

func active():
	if is_multiplayer_authority():
		var speed = champion.speed_final
		champion.speed_final = 0
		self.position = champion.position
		
		self.show()
		animation.play("spell2_dash")
		
		await get_tree().create_timer(0.1).timeout
		
		champion.position += ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), 90)
		self.position = champion.position
		champion.speed_final = speed

		await get_tree().create_timer(0.1).timeout

		animation.stop()
		self.hide()
