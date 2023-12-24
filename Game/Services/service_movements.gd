extends Node

var target_position = Vector2.ZERO
var direction = Vector2.ZERO
var angle = direction.angle()
	
func move(character, animation, speed):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		target_position = character.get_global_mouse_position()
		
	character.direction = (target_position - character.position).normalized()
	character.velocity = character.direction * speed
	
	if (character.state_movement == State.StateMovement.SLOWED):
		character.velocity *= 0.5
	elif (character.state_movement == State.StateMovement.STUNNED or character.state_movement == State.StateMovement.IMMOBILE):
		character.velocity *= 0
	
	character.move_and_collide(character.velocity)

	play_movement_animation(character, animation)
	
func play_movement_animation(character, animation):
	angle = character.direction.angle() 
	angle = rad_to_deg(angle)  
	if angle >= -45 && angle <= 45:
		animation.play("walk_right")
	elif angle >= 45 && angle <= 135:
		animation.play("walk_down")
	elif angle >= 135 || angle <= -135:
		animation.play("walk_left")
	else:
		animation.play("walk_up")


