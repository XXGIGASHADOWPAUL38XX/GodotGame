extends IDamagingCollision

var modulate_bool: bool = false
const SCALE_PER_MODULATE_RATIO = 0.7
const EARTHQUAKE_DURATION = 4

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 2.0
		damage_ratio = 0.0
		
		retrigger = true
		retrigger_time = 0.5
		# ------------------------------------ #
		
			
		self.modulate.a = 0.15
		await super._ready()

func _process(delta):
	if is_multiplayer_authority() && self.visible:
		modulate_bool = ServiceSpell.modulate_obj(self, modulate_bool, 0.2, 0.3, 0.006)
		#self.scale = Vector2(self.modulate.a * SCALE_PER_MODULATE_RATIO, self.modulate.a * SCALE_PER_MODULATE_RATIO)

func active():
	self.show()
	
	await get_tree().create_timer(EARTHQUAKE_DURATION).timeout
	self.hide()

