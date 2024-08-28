extends IControllerKeyPressed

class_name IControllerSpell

var spells = []

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		await super.after_ready()
		spells = get_spells()
	
func get_spells(parent=self):
	var spells = []
	for p in parent.get_children():
		if !p is IActive:
			spells += get_spells(p)
		else:
			spells.append(p)
			
	return spells
	
