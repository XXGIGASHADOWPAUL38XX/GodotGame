extends IPlaceholderSpells

var all_cubes

var controller_laser

# Called when the node enters the scene tree for the first time.
func after_ready():
	await super.after_ready()
	#!!
	await get_tree().create_timer(0.1).timeout
	
	controller_laser = $ctrlr_lasers
	all_cubes = get_all_cubes()

func get_all_cubes(parent=self):
	var all_cubes = []
	for p in parent.get_children():
		if (!p is CharacterBody2D):
			all_cubes += get_all_cubes(p)
		else:
			all_cubes.append(p)
			
	return all_cubes
