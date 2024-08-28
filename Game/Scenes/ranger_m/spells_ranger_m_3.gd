extends IControllerKeyPressed

func after_ready():
	key = KEY_E
	coltdown_time = 4
	await super.after_ready()

func active():
	coltdown.start()
	for spell3_per_champ in $dp_spell_3.get_children().filter(func(spell): return spell.name.begins_with('spell')):
		spell3_per_champ.can_active()

func send_to_spell4(frame_number):
	self.get_parent().get_node('spells_ranger_m_4').mark_number += 1
