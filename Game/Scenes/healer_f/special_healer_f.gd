extends Area2D

var cd_spell = 3.0
var coltdown_spell: Timer
var HUD
var service_time = preload("res://Game/Services/service_time.gd").new()

func _ready():
	if is_multiplayer_authority():
		coltdown_spell = service_time.init_timer(self, cd_spell)
		
		var index = 1
		for ally in ServiceScenes.alliesNode:
			Servrpc.any(self, 'duplicate_spell', [ally, index])
			index += 1
			
func _process(_delta):
	if is_multiplayer_authority():
		if Input.is_key_pressed(KEY_D) && coltdown_spell.time_left == 0:
			coltdown_spell.start()
			spell_launch()
			
		if (HUD == null):
			HUD = ServiceScenes.getMainScene().get_node('stats_heros')
		else:
			HUD.bindTo(coltdown_spell, 4)
			
func spell_launch():
	for spell in get_parent().get_children().filter(func(obj): return obj.name.begins_with('special_healer_f_R')):
		spell.spell_purge_allies()
		
func duplicate_spell(node, index):
	var MULTIPSYNC = get_parent().get_node('MultiplayerSynchronizer')
	var spell_duplicated = self.duplicate()
	spell_duplicated.set_multiplayer_authority(self.get_multiplayer_authority())
	
	spell_duplicated.set_name(self.name + '_R' + str(index))
	spell_duplicated.set_script(preload("res://Game/Scenes/healer_f/special_healer_f_dp.gd"))
	
	get_parent().add_child.call_deferred(spell_duplicated)
	spell_duplicated.player = node
	
	await get_tree().create_timer(1).timeout
	
	MULTIPSYNC.replication_config.add_property(spell_duplicated.name + ":position")
	MULTIPSYNC.replication_config.add_property(spell_duplicated.name + ":visible")
	MULTIPSYNC.replication_config.add_property(spell_duplicated.name + ":modulate")
#	MULTIPSYNC.replication_config.add_property(spell_duplicated.name + "/spells_healer_f_4_anim:frame")


