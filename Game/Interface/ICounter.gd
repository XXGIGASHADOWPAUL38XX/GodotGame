class_name ICounter

extends IDamagingSpell

var func_on_spell_entered: Array[Callable]

var spell_hitted

var CONF_DETECT_WITH_SP
var HAS_DMG_EFFECT = false

func _ready():
	self.area_entered.connect(func(obj): 
		if CONF_DETECT_WITH_SP.find(obj) != -1 && obj.visible:
			spell_entered(obj)
	)
	
	await super._ready()
	
	if CONF_DETECT_WITH_SP == null:
		CONF_DETECT_WITH_SP = ServiceScenes.ennemiesNode.map(func(obj): return get_all_ennemies_spells(obj))
		CONF_DETECT_WITH_SP = CONF_DETECT_WITH_SP.reduce(func(a, b): return a + b)

func spell_entered(spell): #FAIRE LES DEGATS
	spell_hitted = spell
	for fc in func_on_spell_entered:
		var node = fc.get_object()
		fc.call()
		
func get_all_ennemies_spells(node):
	var spells = []
	if node is ICollision:
		spells.append(node)
	else:
		for child in node.get_children():
			var child_spells = get_all_ennemies_spells(child)
			spells += child_spells

	return spells

func collision():
	if self.visible && ennemies_in.find(player_hitted) != -1 && HAS_DMG_EFFECT:
		send_spell()
