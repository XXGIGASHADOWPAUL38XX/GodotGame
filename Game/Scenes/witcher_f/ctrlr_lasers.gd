extends IControllerActive

var dp_spell

# Called when the node enters the scene tree for the first time.
func _ready():
	await super._ready()
	dp_spell = $dp_spell

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# --------------------- CUBE FUNCTIONS --------------------------- #
func get_active_cubes():
	return spells_placeholder.all_cubes.filter(func(c): return c.visible)

# --------------------- SPELLS FUNCTIONS --------------------------- #
func all_spells():
	return dp_spell.get_children().filter(func(s): return s is IActive)

func get_inactive_spell():
	return all_spells().filter(func(c): return !c.visible)
	
func launch_lasers(cube):
	for active_cube in get_active_cubes().filter(func(c): return c != cube):
		var spell = get_inactive_spell()[0]
		spell.can_active(cube, active_cube)
