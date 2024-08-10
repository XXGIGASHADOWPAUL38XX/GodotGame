extends IDamagingCollision

var coltdown_wave = Timer.new()
var cd_wave = 8.0

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.0
		# ------------------------------------ #
		
		await super._ready()
		coltdown_wave = service_time.init_timer(self, cd_wave)

func active():
	if is_multiplayer_authority() && coltdown_wave.time_left == 0:
		coltdown_wave = service_time.init_timer(self, cd_wave)
		coltdown_wave.start()
		
		self.global_position = ServiceScenes.championNode.global_position
		self.scale = Vector2(0.6, 0.6)
		self.modulate.a = 0.5
		self.show()
		
		for i in range(25):
			self.scale = self.scale * 1.05
			self.modulate.a -= 0.03
			await get_tree().create_timer(0).timeout
			
		self.hide()
