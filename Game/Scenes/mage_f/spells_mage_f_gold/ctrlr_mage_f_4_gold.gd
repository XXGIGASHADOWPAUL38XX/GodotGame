extends IControllerKeyPressed

var spell

func _ready():
	if is_multiplayer_authority():
		key = KEY_SPACE
		coltdown_time = 13
		
		spell = $spell_mage_f_4_gold
		
		await super._ready()
		cond_spells.append(Callable(self, 'launch_spell_cond'))	

func active():
	super.active()
	spell.can_active()

func launch_spell_cond():
	return ServiceScenes.championNode.orb_kind == spell.orb_kind
