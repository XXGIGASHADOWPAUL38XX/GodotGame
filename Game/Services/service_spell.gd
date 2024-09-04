extends Node
	
func set_in_front(champion: Node2D, distance: int, incl: int=0):
	var direction = champion.global_transform.basis_xform(Vector2.RIGHT)
	direction = direction.rotated(champion.rotation + deg_to_rad(incl))
	return direction.normalized() * distance
		
func is_close_to(obj1, obj2, distance):
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

func modulate_obj(node: Node, modulate_up: bool, modulate_min=0.5, modulate_max=1, modulate_spd=0.005):
	if node.modulate.a <= modulate_min:
		modulate_up = true
	elif node.modulate.a >= modulate_max:
		modulate_up = false
		
	if modulate_up == true:
		node.modulate.a += modulate_spd
	else:
		node.modulate.a -= modulate_spd
		
	return modulate_up

func push_ennemy_global(node, champion_to_push, push_strength, circular_algorithm=false, retry_instance=2):
	if circular_algorithm:
		Servrpc.send_to_id(champion_to_push.get_multiplayer_authority(), self, 'push_ennemy_ca', 
			[node, champion_to_push, push_strength, retry_instance])
	else:
		Servrpc.send_to_id(champion_to_push.get_multiplayer_authority(), self, 'push_ennemy', 
			[node, champion_to_push, push_strength, retry_instance]
		)

func push_ennemy(node, champion_to_push, push_strength, retry_instance): #AT RUNTIME, MULTIPLAYER_AUTHORITY IS ON ENNEMY VIA A RPC CALL
	var old_position = node.position 
	
	for i in range(push_strength):
		var position_differencial = champion_to_push.position - node.position
		champion_to_push.position = node.position + position_differencial
		await get_tree().create_timer(0).timeout
		
func push_ennemy_ca(node, champion_to_push, push_strength, retry_instance): #AT RUNTIME, MULTIPLAYER_AUTHORITY IS ON ENNEMY VIA A RPC CALL
	var cshape = node.get_node("CollisionShape2D")
	
	for i in range(push_strength):
		var width = cshape.shape.radius * node.scale.x
		var champ_dist_to_center = champion_to_push.position.distance_to(node.position)
		var push_point = node.position + ((champion_to_push.position - node.position).normalized() * (width))
		var position_differencial = push_point - champion_to_push.position
		
		if champ_dist_to_center < width:
			champion_to_push.position = champion_to_push.position + position_differencial
			
		await get_tree().create_timer(0.02).timeout
		
func animation_duration(animation: AnimatedSprite2D):
	return animation.sprite_frames.get_frame_count(animation.animation) / animation.sprite_frames.get_animation_speed(animation.animation)
