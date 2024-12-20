extends IDamagingSpell

var modulate_bool = false
var hit_instance = 0

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 4.0
		damage_ratio = 0.1
		
		
		self.visibility_changed.connect(func(): hit_instance = 0)
		func_on_collision.append(func(): hit_instance += 1)
		# ------------------------------------ #
		
		await super._ready()
		retrigger = true
		retrigger_time = ServiceSpell.animation_duration(animation)

func _process(_delta):
	if is_multiplayer_authority():
		modulate_bool = ServiceSpell.modulate_obj(self, modulate_bool, 0.3, 0.7)
		pass
		
func active(spell_position):
	for i in range(3):
		self.position = spell_position
		self.show()
		animation.play()
			
		await animation.animation_finished
		
		animation.stop()
		self.hide()
		
		await get_tree().create_timer(0.5).timeout
