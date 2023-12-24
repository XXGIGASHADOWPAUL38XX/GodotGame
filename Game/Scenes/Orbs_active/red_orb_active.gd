extends "res://Game/Interface/IDamagingSpell.gd"

var coltdown = Timer.new()
var cd = 15.0
var animation

func _ready():
	if is_multiplayer_authority():
		coltdown = service_time.init_timer(self, cd)
		animation = $animation_dash

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_D) && coltdown.time_left == 0:
			special()
			coltdown.start()

func special():
	self.position = ServiceSpell.set_in_front_mouse(ServiceScenes.championNode, get_global_mouse_position(), 50)
	animation.play('default')

	self.rotation = ServiceSpell.set_in_front_mouse(ServiceScenes.championNode, get_global_mouse_position(), 30).angle()
	ServiceScenes.championNode.set_attribute('speed', 0, 0.2)
	
	self.show()
	
	await get_tree().create_timer(0.15).timeout
	ServiceScenes.championNode.position += ServiceSpell.set_in_front_mouse(
		ServiceScenes.championNode, get_global_mouse_position(), 100)
	
	await get_tree().create_timer(0.2).timeout
	self.hide()
	animation.stop()

