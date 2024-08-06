extends CharacterBody2D

var animation
var collision_shape
var champion

var duration = 3
var duration_timer: Timer
var service_time = preload("res://Game/Services/service_time.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	animation = $anim_cube
	collision_shape = $CollisionShape2D
	
	champion = ServiceScenes.championNode
	duration_timer = service_time.init_timer(self, duration)
	
	self.visibility_changed.connect(func(): collision_shape.disabled == !self.visible)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active():
	self.position = ServiceSpell.distance_range_max(champion.position, get_global_mouse_position(), 250)
	animation.play()
	self.show()
	
	duration_timer.start()
	await duration_timer.timeout
	
	self.hide()
	animation.stop()
