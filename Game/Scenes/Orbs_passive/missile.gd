extends "res://Game/Interface/IDamagingSpell.gd"
const RANGE_MAX = 900

var speed = 25
var drone
var ennemy_in_range

func _ready():
	drone = get_parent().get_node('blue_orb_passive')

func _process(_delta):
	if is_multiplayer_authority():
		super.check_collisions()

func shoot():
	ennemy_in_range = ServiceScenes.ennemiesNode.filter(
		func(ennemy):
			self.global_position.distance_to(ennemy.position) < RANGE_MAX
	)
	var ennemy_to_shoot
	var direction = (ServiceScenes.ennemiesNode[randi_range(0, 1)].position - drone.position).normalized()
	self.position = drone.position + ServiceSpell.set_in_front(drone, 30)
	self.rotation = direction.angle()

	self.show()
	for i in range(18):
		self.position += direction * speed
		await get_tree().create_timer(0).timeout
		
	self.hide()
