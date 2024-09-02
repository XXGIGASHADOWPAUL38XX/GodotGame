extends Node

var target_position_mvmt = Vector2.ZERO
var angle_mvmt
	
func move(character, animation, speed):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		target_position_mvmt = character.get_global_mouse_position()
		
	character.direction = (target_position_mvmt - character.position).normalized()
	character.velocity = character.direction * speed
	
	if (character.curr_state_action == State.StateAction.SLOWED):
		character.velocity *= 0.5
	elif (character.curr_state_action == State.StateAction.STUNNED or character.curr_state_action == State.StateAction.CONCENTRATE):
		character.velocity *= 0
	
	character.move_and_collide(character.velocity)

	play_movement_animation(character, animation)
	
func play_movement_animation(character, animation):
	angle_mvmt = rad_to_deg(character.direction.angle())
	if angle_mvmt >= -45 && angle_mvmt <= 45:
		animation.play("walk_right")
	elif angle_mvmt >= 45 && angle_mvmt <= 135:
		animation.play("walk_down")
	elif angle_mvmt >= 135 || angle_mvmt <= -135:
		animation.play("walk_left")
	else:
		animation.play("walk_up")


