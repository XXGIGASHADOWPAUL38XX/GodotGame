extends IHeros

var direction = Vector2.ZERO
var service_health = preload("res://Game/Services/service_health.gd").new()

func _ready():
	health_bar = $health_bar
	if is_multiplayer_authority():
		animation = $AnimatedSprite2D
		self.show()
		
	await super._ready()

func _process(delta):
	super._process(delta)


