extends Node
	
func set_in_front(champion: Node2D, distance: int, incl: int=0):
	var direction = champion.global_transform.basis_xform(Vector2.RIGHT)
	direction = direction.rotated(champion.rotation + deg_to_rad(incl))
	return direction.normalized() * distance
		
func isCloseTo(obj1, obj2, distance):
	return obj1.global_position.distance_to(obj2.global_position) < distance
	
func set_random_pos(distance: int):
	return Vector2(1, 0).rotated(randf_range(0, 2 * PI)) * distance

func set_in_front_mouse(champion: Node2D, mouse_position, distance: int):
	var direction = mouse_position - champion.global_position
	return direction.normalized() * distance
	
func set_in_front_mouse_incl(champion: Node2D, mouse_position, distance: int, incl_degres: float):
	return set_in_front_mouse(champion, mouse_position, distance).rotated(deg_to_rad(incl_degres))

func distance_range_max(champion_position, mouse_position, distance_max):
	if (champion_position.distance_to(mouse_position) <= distance_max):
		return mouse_position
		
	var distance_max_value = (mouse_position - champion_position).normalized() * distance_max
	return champion_position + distance_max_value

func modulate_obj(node: Node2D, modulate_up: bool, modulate_min=0.5, modulate_max=1, modulate_spd=0.01):
	if node.modulate.a <= modulate_min:
		modulate_up = true
	elif node.modulate.a == modulate_max:
		modulate_up = false
		
	if modulate_up == true:
		node.modulate.a += modulate_spd
	else:
		node.modulate.a -= modulate_spd
	return modulate_up
