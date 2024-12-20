extends IPlaceholderSpells

var current_weapon = weapons.LAMES

var change_weapon

enum weapons {
	LAMES,
	RING
}

# Called when the node enters the scene tree for the first time.
func _ready():
	change_weapon = $ctrlr_spell_4/change_weapon
	enable_disable_weapons()
	await super._ready()
	
	
func switch_weapon():
	var current_weapon_key = weapons.keys().filter(func(w): return weapons[w] != current_weapon)[0]
	current_weapon = weapons[current_weapon_key]
	change_weapon.animation.animation = current_weapon_key.to_lower()
	enable_disable_weapons()
	
func enable_disable_weapons():
	weapons.keys().map(func(w): 
		var weapon_node = self.get_node("weapon_" + w.to_lower())
		if weapons[w] == current_weapon:
			weapon_node.process_mode = Node.PROCESS_MODE_INHERIT 
		else:
			weapon_node.process_mode = Node.PROCESS_MODE_DISABLED
			get_spells_and_animations().map(func(s): s.hide())
	)
	
func get_spells_and_animations(parent=self):
	var spells = []
	for p in parent.get_children():
		if !(p is IActive || p is IAnimation):
			spells += get_spells_and_animations(p)
		else:
			spells.append(p)
			
	return spells
