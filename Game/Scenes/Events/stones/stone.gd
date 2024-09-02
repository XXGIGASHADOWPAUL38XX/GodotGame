extends IPhysicalSpell

var display_stones: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IPHYSICALSPELL #
		damage_base = 5.0
		# ------------------------------------ #
		
		CONF_DETECT_WITH = ServiceScenes.allPlayersNode
	
		cshape = $CollisionShape2D
		await super._ready()
		
		animation.animation_finished.connect(collision)
		
		launch_timer()

func fall():
	animation.play('fall')
	
	await get_tree().create_timer(1).timeout
	modulate_down()

func modulate_down():
	for i in range(10):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.03).timeout
		
	self.hide()
	launch_timer()

func launch_timer():
	display_stones = service_time.init_timer(self, randi_range(2, 5))
	display_stones.timeout.connect(pre_fall)
	display_stones.start()

func pre_fall():
	self.global_position = Vector2(
		randf_range(0, get_window().size.x * 2),
		randf_range(0, get_window().size.y * 2)
	)
	
	self.modulate.a = 1
	self.show()
	animation.play('pre_fall')
	
	await get_tree().create_timer(0.5).timeout
	fall()
	
