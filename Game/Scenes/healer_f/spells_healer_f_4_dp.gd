extends IDamagingSpell

var player # INSTANCIE LORS DE LA DUPLICATION

var healing_base: float

func _ready():
#	self.hidden.connect(func(): self.position = Vector2(-1000, -1000))
	CONF_DETECT_WITH = [ServiceScenes.entities.alliesNode, ServiceScenes.entities.ennemiesNode]
	
	# DEFINITION VARIABLES IDAMAGING SPELL #
	damage_base = 8.0
	healing_base = 8.0
	damage_ratio = 0.2
	# ------------------------------------ #
		
	await super._ready()
			
func _process(_delta):
	pass
			
func spell4_heal():
	self.modulate.a = 1
	self.global_position = player.position
	self.show()
	
	self.get_node('spells_healer_f_4_anim').animation = 'ennemy' if ServiceScenes.get_property_from_player(
		player, '.is_ally()'
	) == false else 'ally'
	
	for i in range(10):
		self.global_position = player.global_position
		self.rotate(deg_to_rad(36))
		await get_tree().create_timer(0).timeout
	
	if player.name == 'ranger_m' or player.name == 'mage_f':
		Servrpc.send_to_id(player.get_multiplayer_authority(), self, 'test', [])
	
	for i in range(10):
		self.global_position = player.global_position
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.02).timeout
		
	self.hide()

func test():
	var m = get_parent().get_node('MultiplayerSynchronizer') as MultiplayerSynchronizer

func output_damage_f(champion_hitted):
	if ServiceScenes.is_on_same_team(self, champion_hitted):
		return (healing_base + (damage_ratio * champion.damage_final)) * -1
	return damage_base + (damage_ratio * champion.damage_final) * (1 - (champion_hitted.armor_final / 100))


