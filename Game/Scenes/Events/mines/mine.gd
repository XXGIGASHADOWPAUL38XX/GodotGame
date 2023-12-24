extends "res://Game/Interface/IDamagingSpell.gd"

var cshape: CollisionShape2D
var animation: AnimatedSprite2D

var display_mines: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		CONF_DETECT_WITH = ServiceScenes.allPlayersNode
		super._ready()
	
		cshape = $CollisionShape2D
		animation = $anim_mine as AnimatedSprite2D
		
		self.modulate.a = 0
		self.scale = Vector2(0.5, 0.5) 
		animation.animation = 'mine'
		animation.animation_changed.connect(
			func(): 
				cshape.disabled != (animation.animation == 'explosion')
				self.scale = Vector2(1.5, 1.5) if animation.animation == 'explosion' else Vector2(0.5, 0.5) 
		)
		
		self.global_position = Vector2(
			randi_range(0, get_window().size.x * 2),
			randi_range(0, get_window().size.y * 2)
		)
		
		body_entered.connect(func(obj): hitted())
		
		launch_timer()

func launch_timer():
	display_mines = service_time.init_timer(self, 3)
	display_mines.timeout.connect(display_mines_func)
	display_mines.start()

func display_mines_func():
	for i in range(10):
		if get_tree() != null:
			self.modulate.a += 0.05
			await get_tree().create_timer(0.03).timeout
		
	for i in range(10):
		if get_tree() != null:
			self.modulate.a -= 0.05
			await get_tree().create_timer(0.03).timeout
		
	launch_timer()
	
func hitted():
	animation.animation = 'explosion'
	animation.play()
	
	self.modulate.a = 1

	#!! VERIFIER MULTIJOUEUR ET IMPLEMENTER
	animation.animation_finished.connect(
		func():
			queue_free()
	)
