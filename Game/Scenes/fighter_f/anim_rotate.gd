extends IAnimation

var champion
var rotate_speed = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0.6
	await super._ready()
	champion = ServiceScenes.championNode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		if self.visible:
			self.rotate(deg_to_rad(rotate_speed))
			self.position = champion.position
