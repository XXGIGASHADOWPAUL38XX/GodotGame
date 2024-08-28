extends IPlaceholderSpells

var shadows: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		await super._ready()
		
		shadows = get_all_shadows()

func get_all_shadows():
	return all_actives.filter(func(a): return a.get('is_shadow') && a.is_shadow)


