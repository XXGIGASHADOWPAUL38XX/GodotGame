extends IAnimation

var champion
var rotate_speed = 20

func _ready():
	await super._ready()
	champion = ServiceScenes.championNode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		if self.visible:
			self.position = champion.position
			self.rotate(deg_to_rad(rotate_speed))

func active():
	self.show()
	champion.position += (get_global_mouse_position() - champion.position).normalized() * 50
	
	await get_tree().create_timer(0.4).timeout
	self.hide()
