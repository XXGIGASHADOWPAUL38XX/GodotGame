extends IDamagingSpell

var modulate_bool = false

var healing_base

func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 2.0
		healing_base = 2.0
		damage_ratio = 0.05
		# ------------------------------------ #
		
		CONF_DETECT_WITH = ServiceScenes.alliesNode
		
			
		await super.after_ready()

func _process(_delta):
	if is_multiplayer_authority():
		modulate_bool = await ServiceSpell.modulate_obj(self, modulate_bool, 0.15, 0.4)
		pass
		
func active():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 300)
	self.show()
	animation.play("default")
		
	await get_tree().create_timer(3).timeout
	animation.stop()
	self.hide()
	
func output_damage_f(champion_hitted):
	if ServiceScenes.is_on_same_team(self, champion_hitted):
		return (healing_base + (damage_ratio * champion.damage_final)) * -1
	return damage_base + (damage_ratio * champion.damage_final) * (1 - (champion_hitted.armor_final / 100))
