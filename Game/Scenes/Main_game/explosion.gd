extends Node

var random_explosion: Timer
var service_time = ServiceTime.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	random_explosion = service_time.init_timer(self, randf_range(2.0, 5.0))
	random_explosion.start()
	random_explosion.timeout.connect(launch_explosion)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
		if random_explosion == null:
			random_explosion = service_time.init_timer(self, randf_range(2.0, 5.0))
			random_explosion.start()
	
func launch_explosion():
	var heros = ServiceScenes.entities.ennemiesNode.pick_random()
	
	$warning.position = Vector2(
		heros.position.x + randf_range(-80, 80),
		heros.position.y + randf_range(-80, 80)
	)
	
	$explosion.position = $warning.position
	
	$warning/animatedSprite.play("default")
	$warning.show()
	
	await get_tree().create_timer(0.8).timeout 

	$warning.hide()
	$explosion/animatedSprite.play("default")
	$explosion.show()
	
	await get_tree().create_timer(0.4).timeout 
	$explosion.hide()
	random_explosion.start()
	
