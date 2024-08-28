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
		weapon_node.process_mode = Node.PROCESS_MODE_INHERIT if weapons[w] == current_weapon else Node.PROCESS_MODE_DISABLED
	)
