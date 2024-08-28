extends IHeros

var direction = Vector2.ZERO
var service_health = preload("res://Game/Services/service_health.gd").new()

func after_ready():
	if is_multiplayer_authority():
		self.show()
		
	await super.after_ready()

func _process(delta):
	super._process(delta)

