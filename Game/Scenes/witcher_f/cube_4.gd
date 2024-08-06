extends CharacterBody2D

var animation
var collision_shape
var champion

var duration = 3
var duration_timer: Timer
var service_time = preload("res://Game/Services/service_time.gd").new()

var angle
var controller

# Called when the node enters the scene tree for the first time.
func _ready():
	animation = $anim_cube
	collision_shape = $CollisionShape2D
	
	champion = ServiceScenes.championNode
	duration_timer = service_time.init_timer(self, duration)
	controller = get_parent().get_parent()
	
	self.visibility_changed.connect(func(): collision_shape.disabled == !self.visible)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func post_dp_script(id):
	angle = id * 60

func active():
	var zone_ult_polygon = controller.zone_ult.collision.polygon
	var zone_ult_side_height = zone_ult_polygon[0].distance_to(zone_ult_polygon[1]) * controller.zone_ult.scale
	
	self.position = controller.zone_ult.position + (Vector2.UP * zone_ult_side_height).rotated(deg_to_rad(angle))
	self.animation.play()
	self.show()

