extends CharacterBody2D

var cd = 2.0
var coltdown: Timer

var distance: float = 45.0  # Distance from center_object
var rotation_speed: float = 2  
var current_angle: float = 0.0
var missile
var direction

var service_time = preload("res://Game/Services/service_time.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		missile = get_parent().get_node('blue_orb_p_missile')
		coltdown = service_time.init_timer(self, cd) 
		coltdown.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_multiplayer_authority():
		current_angle += rotation_speed * delta
		direction = Vector2(cos(current_angle), sin(current_angle))
		self.position = ServiceScenes.championNode.position + (direction * distance)
			
		if (coltdown.time_left == 0):
			missile.shoot()
			coltdown = service_time.init_timer(self, cd) 
			coltdown.start()
