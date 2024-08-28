extends IControllerKeyPressed

var spell

func after_ready():
	if is_multiplayer_authority():
		key = KEY_Z
		coltdown_time = 6
		
		spell = $spell_mage_f_2_gold
		
		await super.after_ready()
		cond_spells.append(Callable(self, 'launch_spell_cond'))	

func active():
	super.active()
	spell.can_active()

func launch_spell_cond():
	return ServiceScenes.championNode.orb_kind == spell.orb_kind
