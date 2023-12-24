extends "res://Game/Interface/IHeros.gd"

var animation: AnimatedSprite2D
var direction = Vector2.ZERO
var service_health = preload("res://Game/Services/service_health.gd").new()

func _ready():
	health_bar = $health_bar
	super._ready()
	if is_multiplayer_authority():
		animation = $AnimatedSprite2D
		self.show()

func _process(delta):
	if is_multiplayer_authority():
		ServiceMovements.move(self, animation, speed_final * delta)
		ServiceHealth.setBar(self, health_bar)


