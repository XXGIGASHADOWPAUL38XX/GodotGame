extends IDamagingSpell

var healing_base
var key_champion_marked

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 6.0
		damage_ratio = 0.15
		# ------------------------------------ #
		
		CONF_DETECT_WITH = [ServiceScenes.entities.alliesNode, ServiceScenes.entities.ennemiesNode]
			
		await super._ready()
			
func _process(_delta):
	if is_multiplayer_authority() && self.visible:
		self.position = key_champion_marked.position
		
func active():
	animation.animation = 'ally' if key_champion_marked in ServiceScenes.entities.alliesNode else 'ennemy'	
	self.modulate.a = 1
	self.show()
	animation.play()
	await animation.animation_finished

	self.hide()

func post_dp_script(id, nbr_dupl):
	key_champion_marked = champions_sorted()[id - 1]
	
func champions_sorted():
	var entities = ServiceScenes.entities.ennemiesNode + ServiceScenes.entities.alliesNode
	entities.sort()
	return entities

func output_damage_f(champion_hitted):
	var output = damage_base + (damage_ratio * champion.damage_final) * (1 - (champion_hitted.armor_final / 100))
	return output * -1 if key_champion_marked in ServiceScenes.entities.alliesNode else output
