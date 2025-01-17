extends IControllerKeyPressed

var spell

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_ultimate']
		coltdown_time = 13
		
		spell = $spell_mage_f_4_gold
		
		await super._ready()
		cond_spells.append(Callable(self, 'launch_spell_cond'))	

func active():
	await super.active()
	spell.active()

func launch_spell_cond():
	return ServiceScenes.championNode.orb_kind == spell.orb_kind
