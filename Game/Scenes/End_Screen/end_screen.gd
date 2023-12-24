extends Node2D
var camera

func _ready():
	camera = ServiceScenes.getCamera()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = Vector2(camera.offset)
	
func end_game(victory: bool):
	self.modulate.a = 0
	$AnimatedSprite2D.play("default")
	
	if victory == true:
		$Label.text = 'ROUND WON'
	else:
		self.modulate = Color.RED
		$Label.text = 'ROUND LOST'
	
	self.show()
	
	for i in range(10):
		self.modulate.a += 0.1
		await get_tree().create_timer(0.05).timeout
		
	await get_tree().create_timer(3.8).timeout
	for i in range(10):
		self.modulate.a -= 0.1
		await get_tree().create_timer(0.05).timeout
	
	self.hide()

