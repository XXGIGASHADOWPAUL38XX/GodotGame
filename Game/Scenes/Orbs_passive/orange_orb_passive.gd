extends CharacterBody2D

var booleaen = false
var service_time = preload("res://Game/Services/service_time.gd").new()

var coltdown_wave = Timer.new()
var cd_wave = 8.0

func _ready():
	coltdown_wave = service_time.init_timer(self, cd_wave)
	ServiceScenes.championNode.add_func_hitted(Callable(special))
			
func special():
	if is_multiplayer_authority() && coltdown_wave.time_left == 0:
		coltdown_wave.start()
		self.position = ServiceScenes.championNode.position
		self.scale = Vector2(0.6, 0.6)
		self.modulate.a = 0.5
		self.show()
		
		for i in range(16):
			self.scale = self.scale * 1.05
			self.modulate.a += 0.03
			await get_tree().create_timer(0).timeout
			
		self.hide()

