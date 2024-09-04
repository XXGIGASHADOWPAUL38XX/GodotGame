extends IDamagingSpell

var cd_spell4 = 13.0
var coltdown_spell4: Timer
var passive: CharacterBody2D
var HUD
var shadow_node
var spell1

func _ready():	
	spell1 = get_parent().get_node('spells_ninja_m_1')
	champion = ServiceScenes.championNode
	shadow_node = get_parent().get_node('animations').get_node('shadow')
	
	coltdown_spell4 = service_time.init_timer(self, cd_spell4)
	
	for i in range (1, 4):
		duplicate_spell_1(i)

func _process(delta):
	if is_multiplayer_authority():
		pass

func spell4_marks():
	for i in range (1, 4): #1, 2, 3
		get_parent().get_node('spells_ninja_m_4_R' + str(i)).spell4_mark(
			'shadow_' + str(i), i * 120)

func duplicate_spell_1(i):
	var MULTIPSYNC = get_parent().get_node('MultiplayerSynchronizer')
	
	var spell4_unit = spell1.duplicate()
	spell4_unit.set_name('spells_ninja_m_4_R' + str(i))
	spell4_unit.set_script(preload('res://Game/Scenes/ninja_m/spells_ninja_m_4.gd'))
	get_parent().add_child.call_deferred(spell4_unit)

	MULTIPSYNC.replication_config.add_property('spells_ninja_m_4_R' + str(i) + ":global_position")
	MULTIPSYNC.replication_config.add_property('spells_ninja_m_4_R' + str(i) + ":modulate")
	MULTIPSYNC.replication_config.add_property('spells_ninja_m_4_R' + str(i) + ":visible")
	MULTIPSYNC.replication_config.add_property('spells_ninja_m_4_R' + str(i) + ":rotation")
