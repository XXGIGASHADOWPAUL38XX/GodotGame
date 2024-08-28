extends IDamagingSpell

var healing_base
var key_champion_marked

func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		CONF_DETECT_WITH = ServiceScenes.alliesNode + ServiceScenes.ennemiesNode
		
			
		await super.after_ready()
			
func _process(_delta):
	if is_multiplayer_authority():
		pass
		
func active():
	animation.animation = 'ally' if key_champion_marked in ServiceScenes.alliesNode else 'ennemy'	
	self.modulate.a = 1
	self.position = key_champion_marked.position
	self.show()

	for i in range(10):
		self.position = key_champion_marked.position
		self.rotate(deg_to_rad(36))
		await get_tree().create_timer(0).timeout

	for i in range(10):
		self.position = key_champion_marked.position
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.02).timeout

	self.hide()

func post_dp_script(id, nbr_dupl):
	key_champion_marked = champions_sorted()[id - 1]
	
func champions_sorted():
	var entities = ServiceScenes.ennemiesNode + ServiceScenes.alliesNode
	entities.sort()
	return entities

func output_damage_f(champion_hitted):
	var output = damage_base + (damage_ratio * champion.damage_final) * (1 - (champion_hitted.armor_final / 100))
	return output * -1 if key_champion_marked in ServiceScenes.alliesNode else output
