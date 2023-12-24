extends CharacterBody2D

var speed = 80.0
var animation:AnimationPlayer
var target_position = Vector2.ZERO
var is_moving = false
var direction = Vector2.ZERO
var health_bar
var service_health = preload("res://Game/Services/service_health.gd").new()

func _ready():
	animation = $AnimationPlayer
	health_bar = get_tree().root.get_node('Node2D').get_node('HealthBarP1')

func _process(delta):
	
	service_health.setBar(self, health_bar)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		target_position = get_global_mouse_position()
		is_moving = true
	
	if is_moving:
		direction = target_position - position
		direction = direction.normalized()
		var velocity = direction * speed_final * delta
#		prout_move_and_collide(velocity)
		
		play_movement_animation()
	
	if position.distance_to(target_position) < velocity.length() * delta:
		is_moving = false
		
func play_movement_animation():
	var angle = direction.angle() 
	angle = rad_to_deg(angle)   
	if angle >= -45 && angle <= 45:
		animation.play("walk_right")
	elif angle >= 45 && angle <= 135:
		animation.play("walk_down")
	elif angle >= 135 || angle <= -135:
		animation.play("walk_left")
	else:
		animation.play("walk_up")
		


