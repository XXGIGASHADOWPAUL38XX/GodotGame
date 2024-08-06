extends AnimatedSprite2D

var service_time = preload("res://Game/Services/service_time.gd").new()

var coltdown = Timer.new()
var cd = 18.0

func _ready():
	if is_multiplayer_authority():
		self.modulate.a = 1
		coltdown = service_time.init_timer(self, cd)

func _process(_delta):
	if is_multiplayer_authority() && Input.is_key_pressed(
	KEY_F) && coltdown.time_left == 0:
		special()
		coltdown.start()

func special():
	self.play("default")
	self.show()
	await get_tree().create_timer(0.3).timeout	
	
	for i in range(10):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0).timeout	
		
	self.hide()
	self.modulate.a = 1
