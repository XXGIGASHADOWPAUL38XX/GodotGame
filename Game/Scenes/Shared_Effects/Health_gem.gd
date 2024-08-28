extends IDamagingCollision

const NUMBER_FRAMES = 4
const MARGIN_SPAWN_X = 600
const MARGIN_SPAWN_Y = 400

var timer_spawn
var modulate_bool: bool = false

var healing_base

# Called when the node enters the scene tree for the first time.
func after_ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		healing_base = 5.0
		# ------------------------------------ #
		
		await super.after_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		modulate_bool = await ServiceSpell.modulate_obj(self, modulate_bool)
		
		if self.visible: 
			$CollisionShape2D.disabled = animation.frame + 1 >= NUMBER_FRAMES
		
func spawn():
	ServiceAnnounce.set_announce(
		'A health gem has appeared',
		'res://Game/Ressources/Background/Gems/health_gem_icon.png',
		'res://Game/Ressources/Background/Gems/health_gem_icon.png'
	)
	
	animation.animation = 'default'
	self.modulate.a = 1
	self.position = Vector2(
		randf_range(MARGIN_SPAWN_X, get_window().size.x - MARGIN_SPAWN_X), 
		randf_range(MARGIN_SPAWN_Y, get_window().size.y - MARGIN_SPAWN_Y))
	self.show()

func take_damage(variant1=null, variant2=null):
	if (animation.frame + 1 < NUMBER_FRAMES):
		animation.frame += 1
	else:
		die()

func die():
	animation.play('heal')
	
	$CollisionShape2D.shape.radius = 35
	await get_tree().create_timer(10).timeout
	$CollisionShape2D.shape.radius = 18
	
	self.hide()
	timer_spawn.start()
	animation.play('default')
	
func output_damage_f(champion_hitted):
	return healing_base * -1
