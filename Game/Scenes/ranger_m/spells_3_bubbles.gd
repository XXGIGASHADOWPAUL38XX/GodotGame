extends IActive

var key_ennemy_marked
var animation

# Called when the node enters the scene tree for the first time.
func _ready():
	animation = $anim_bubbles
	await super._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func active(target_position):
	self.position = target_position
	var speed = 10

	self.show()
	
	while !ServiceSpell.isCloseTo(champion, self, 3):
		var direction = champion.position - self.position
		var velocity = direction.normalized() * speed
		
		self.position += velocity
		await get_tree().create_timer(0.01).timeout
		
	spell_controller.send_to_spell4(animation.frame)
	self.hide()
