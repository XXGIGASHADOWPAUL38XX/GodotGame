extends IControllerSpell

var spell

func _ready():
	if is_multiplayer_authority():
		key = KEY_Z
		coltdown_time = 6
		
		spell = $spell_mage_f_2_gold
		
		await super._ready()
		cond_spells.append(Callable(self, 'launch_spell_cond'))	

func active():
	coltdown.start()
	spell.active()

func launch_spell_cond():
	return ServiceScenes.championNode.orb_kind == spell.orb_kind
