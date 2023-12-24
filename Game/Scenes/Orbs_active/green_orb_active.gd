extends "res://Game/Interface/IDamagingSpell.gd"

var coltdown = Timer.new()
var cd = 12.0

func _ready():
	coltdown = service_time.init_timer(self, cd)

func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_D) && coltdown.time_left == 0:
			special()
			coltdown.start()

func special():
	self.modulate.a = 0.02
	self.show()
	for i in range (5):
		self.global_position = ServiceScenes.championNode.position
		for j in range(10):
			self.modulate.a += 0.06
			await get_tree().create_timer(0).timeout
	
		for j in range(10):
			self.modulate.a -= 0.06
			await get_tree().create_timer(0).timeout	
	self.hide()
