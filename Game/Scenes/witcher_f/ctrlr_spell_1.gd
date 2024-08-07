extends IControllerSpell

var dp_cube_s1: IDuplication
var dp_spell: IDuplication

var cube_file: Array = []

func _ready():
	if is_multiplayer_authority():
		key = KEY_A
		coltdown_time = 3
		
		dp_cube_s1 = $dp_cube_1
		dp_spell = $dp_spell
		await super._ready()

func active():
	var cube
	var inactive_cubes = get_inactive_cubes(cubes_s1())
	
	if inactive_cubes.size() == 0:
		cube = get_last_cube_s1()
	else:
		cube = inactive_cubes[0]
		cube_file.append(cube)
		
	cube.active()
	
	inactive_cubes = get_inactive_cubes(cubes_s1())
	if inactive_cubes.size() == 0:
		coltdown.start()

	for active_cube in get_active_cubes(all_cubes()).filter(func(c): return c != cube):
		var spell = get_inactive_spell()[0]
		spell.active(cube, active_cube)

# --------------------- CUBES FUNCTIONS --------------------------- #
func get_active_cubes(cube_list):
	return cube_list.filter(func(c): return c.visible)

func get_inactive_cubes(cube_list):
	return cube_list.filter(func(c): return !c.visible)
	
func cubes_s1():
	return dp_cube_s1.get_children().filter(func(s): return s is CharacterBody2D)

func cubes_s4():
	return spells_placeholder.cubes_s4

func all_cubes():
	return cubes_s1() + cubes_s4()

func get_last_cube_s1():
	var last_cube_file = cube_file[0]
	cube_file.remove_at(0)
	
	return last_cube_file
	
# --------------------- SPELLS FUNCTIONS --------------------------- #
func all_spells():
	return dp_spell.get_children().filter(func(s): return s is IActive)

func get_inactive_spell():
	return all_spells().filter(func(c): return !c.visible)
