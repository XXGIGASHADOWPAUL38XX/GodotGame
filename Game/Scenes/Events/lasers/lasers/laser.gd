extends "res://Game/Interface/IDamagingSpell.gd"

var random_laser: Timer = Timer.new()

var starter_points_scene

var cshape: CollisionShape2D
var animation: AnimatedSprite2D
var base_size_x

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		CONF_DETECT_WITH = ServiceScenes.allPlayersNode
		super._ready()
		
		cshape = $CollisionShape2D
		animation = $anim_laser
		
		animation.animation == 'pre_laser'
		animation.animation_changed.connect(func(obj): cshape.disabled != (animation.animation == 'laser'))
	
		base_size_x = cshape.shape.height
		
		starter_points_scene = get_parent().get_parent().get_node('starter_points')
		
		launch_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		pass
	
func launch_laser():
	var starter_points = starter_points_scene.get_children().filter(
		func(obj): return obj.name.begins_with('starter_point')
	)
	
	var input = starter_points[randi_range(0, starter_points.size() - 1)]
	
	# POUR NE PAS POUVOIR PRENDRE DEUX FOIS LE MÊME POINT
	starter_points.remove_at(starter_points.find(input)) 
	
	var output = starter_points[randi_range(0, starter_points.size() - 1)]
	
	self.global_position = (input.global_position + output.global_position) / 2
	self.rotation = (output.position - input.position).angle()
	self.scale.x = input.global_position.distance_to(output.global_position) / base_size_x
	
	
	animation.animation == 'pre_laser'
	self.show()
	await get_tree().create_timer(0.5).timeout
	
	animation.animation == 'laser'
	await get_tree().create_timer(0.5).timeout
	self.hide()
	
	launch_timer()

func launch_timer():
	random_laser = service_time.init_timer(self, randf_range(1.0, 4.0))
	random_laser.timeout.connect(launch_laser)
	random_laser.start()
