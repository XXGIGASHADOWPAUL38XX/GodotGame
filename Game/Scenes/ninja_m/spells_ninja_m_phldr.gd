extends IPlaceholderSpells

var shadows: Array

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		await super.after_ready()
		
		shadows = get_all_shadows()

func get_all_shadows():
	return all_actives.filter(func(a): return a.get('is_shadow') && a.is_shadow)


