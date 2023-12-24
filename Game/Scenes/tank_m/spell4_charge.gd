extends AnimatedSprite2D

var champion
var speed = 15
var HUD

func _ready():
	if is_multiplayer_authority():
		champion = ServiceScenes.championNode

func _process(_delta):
	pass

func charge(): #VISIBILITY HANDELED BY SPELLS_TANK_M_4
	self.play('default')

	self.global_position = champion.position + ServiceSpell.set_in_front_mouse(
		champion, get_global_mouse_position(), 200)
	self.rotation = (self.global_position - champion.position).angle()
	
	await get_tree().create_timer(1.5).timeout 

	self.stop()
