extends IDamagingSpell

var speed = 8
var rotate_speed = 25


func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 8.0
		damage_ratio = 0.2
		immobile_while_active = true
		# ------------------------------------ #
		
		await super._ready()
		animation = $anim_dash

func _process(_delta):
	if is_multiplayer_authority():
		if self.visible:
			self.rotate(deg_to_rad(rotate_speed))
			self.position = champion.position

func active():
	self.show()

	animation.play()

	for i in range(12):
		champion.position = champion.position + ServiceSpell.set_in_front_mouse(champion, get_global_mouse_position(), speed)
		await get_tree().create_timer(0).timeout

	animation.stop()
	self.hide()
