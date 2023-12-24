extends AnimatedSprite2D

var champion

# Called when the node enters the scene tree for the first time.
func _ready():
	champion = ServiceScenes.championNode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spell3_bubble(target_position):
	self.global_position = target_position
	var speed = 10

	self.show()
	while ServiceSpell.isCloseTo(champion, self, 1) == false:
		var direction = champion.global_position - self.global_position
		var velocity = direction.normalized() * speed
		
		self.global_position += velocity
		await get_tree().create_timer(0.01).timeout
		
	self.hide()
