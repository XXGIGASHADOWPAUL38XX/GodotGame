extends IControllerKeyPressed

var spell

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_2']
		coltdown_time = 6
		
		spell = $spell_mage_f_2_red
		
		await super._ready()
		cond_spells.append(Callable(self, 'launch_spell_cond'))

func active():
	await super.active()
	spell.active()

func launch_spell_cond():
	return ServiceScenes.championNode.orb_kind == spell.orb_kind && ServiceScenes.championNode.orb.visible
