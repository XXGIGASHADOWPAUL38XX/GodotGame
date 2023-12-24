extends "res://Game/Interface/IDamagingSpell.gd"

var champion
var cd_spell = 3.0
var animation: AnimatedSprite2D
var coltdown_spell: Timer
var HUD
var passive

func _ready():
	champion = get_parent().get_parent()
	if is_multiplayer_authority():
		CONF_DETECT_WITH = ServiceScenes.alliesNode + ServiceScenes.ennemiesNode
		super._ready()
		animation = $spells_healer_f_4_anim
		coltdown_spell = service_time.init_timer(self, cd_spell)

		animation.animation = 'ally'
		
		for ally in ServiceScenes.alliesNode.filter(func(obj): return obj != champion):
			Servrpc.any(self, 'duplicate_spell', [ally, 'ally'])
		for ennemy in ServiceScenes.ennemiesNode:
			Servrpc.any(self, 'duplicate_spell', [ennemy, 'ennemy_' + str(ServiceScenes.ennemiesNode.find(ennemy) + 1)])
			
func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_SPACE) && coltdown_spell.time_left == 0:
			coltdown_spell.start()
			spell4_launch()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell, 4)
			
func spell4_launch():
	for spell in get_parent().get_children().filter(func(obj): return obj.name.begins_with('spells_healer_f_4')):
		spell.spell4_heal()
		
func spell4_heal():
	self.modulate.a = 1
	self.global_position = champion.position
	self.show()

	for i in range(10):
		self.global_position = champion.position
		self.rotate(deg_to_rad(36))
		await get_tree().create_timer(0).timeout

	for i in range(10):
		self.global_position = champion.position
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.02).timeout

	self.hide()
	
func duplicate_spell(node, team):
	var MULTIPSYNC = get_parent().get_node('MultiplayerSynchronizer')
	var spell_duplicated = self.duplicate()
	
	spell_duplicated.set_name(self.name + '_' + team)
	spell_duplicated.set_script(preload("res://Game/Scenes/healer_f/spells_healer_f_4_dp.gd"))
	
	get_parent().add_child.call_deferred(spell_duplicated)
	spell_duplicated.player = node
	
	MULTIPSYNC.replication_config.add_property(spell_duplicated.name + ":position")
	MULTIPSYNC.replication_config.add_property(spell_duplicated.name + ":rotation")
	MULTIPSYNC.replication_config.add_property(spell_duplicated.name + ":visible")
	MULTIPSYNC.replication_config.add_property(spell_duplicated.name + ":modulate")
	MULTIPSYNC.replication_config.add_property(spell_duplicated.name + "/spells_healer_f_4_anim:animation")
	
	ServiceScenes.addSpellToChampion(champion, spell_duplicated)

