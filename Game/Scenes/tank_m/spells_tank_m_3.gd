extends IPhysicalSpell

var champion
var animation: AnimatedSprite2D
var passive

func _ready():
	if is_multiplayer_authority():
		animation = $anim_tank_m_3
		super._ready()
		animation.animation_finished.connect(func(obj): collision())

func _process(_delta):
	if is_multiplayer_authority():
		pass
		
func active():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 300)
	self.show()
	animation.play("default")
		
	await animation.animation_finished
	self.hide()
	
	



