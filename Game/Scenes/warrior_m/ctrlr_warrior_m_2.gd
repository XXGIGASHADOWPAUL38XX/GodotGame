extends IControllerKeyPressed

func _ready():
	if is_multiplayer_authority():
		key = ServiceSettings.keys_values['key_spell_2']
		coltdown_time = 6
		cast_time = ServiceSpell.animation_duration($spell_warrior_m_2/Spells_warrior_anim_2) 
			
		await super._ready()

func active():
	await super.active()
	$spell_warrior_m_2.active()

