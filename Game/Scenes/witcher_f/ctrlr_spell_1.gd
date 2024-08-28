extends IControllerKeyPressed

var dp_cube_s1: IDuplication

var cube_file: Array = []

func after_ready():
	if is_multiplayer_authority():
		key = KEY_A
		coltdown_time = 3
		
		dp_cube_s1 = $dp_cube_1
		await super.after_ready()

func active():
	super.active()
	var cube
	var inactive_cubes = get_inactive_cubes(cubes_s1())
	
	if inactive_cubes.size() == 0:
		cube = get_last_cube_s1()
	else:
		cube = inactive_cubes[0]
		cube_file.append(cube)
		
	cube.can_active()
	
	inactive_cubes = get_inactive_cubes(cubes_s1())
	if inactive_cubes.size() == 0:
		spells_placeholder.controller_laser.launch_lasers(cube)

# --------------------- CUBES FUNCTIONS --------------------------- #
func get_inactive_cubes(cube_list):
	return cube_list.filter(func(c): return !c.visible)
	
func cubes_s1():
	return dp_cube_s1.get_children().filter(func(s): return s is CharacterBody2D)

func get_last_cube_s1():
	var last_cube_file = cube_file[0]
	cube_file.remove_at(0)
	
	return last_cube_file
	

