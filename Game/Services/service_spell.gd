extends Node
	
func set_in_front(champion: Node2D, distance: int):
	var direction = champion.global_transform.basis_xform(Vector2.RIGHT)
	direction = direction.rotated(champion.rotation)
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

func modulate_obj(node: Node2D, modulate_up: bool):
	if node.modulate.a <= 0.5:
		modulate_up = true
	elif node.modulate.a == 1:
		modulate_up = false
		
	if modulate_up == true:
		node.modulate.a += 0.01
	else:
		node.modulate.a -= 0.01
	return modulate_up
