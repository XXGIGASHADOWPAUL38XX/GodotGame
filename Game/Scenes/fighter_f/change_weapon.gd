extends IActive

var base_scale

func _ready():
	if is_multiplayer_authority():
		base_scale = self.scale
		
		super._ready()

func _process(_delta):
	pass

func active(): 
	spells_placeholder.switch_weapon()
	self.show()
	animation.play()

	self.position = champion.position
	
	for i in range(20):
		self.position = champion.position
		self.scale *= 1.025
		self.modulate.a -= 0.05
		await get_tree().create_timer(0.01).timeout 
		
	self.hide()
	self.scale = base_scale
	self.modulate.a = 1
