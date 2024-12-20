extends IDamagingCollision

const RANGE_MAX = 900

var speed = 25
var ennemy_in_range = []

var overall_spell

func _ready():
	if is_multiplayer_authority():
		# DEFINITION VARIABLES IDAMAGING SPELL #
		damage_base = 4.0
		damage_ratio = 0.1
		# ------------------------------------ #
		
		overall_spell = get_parent()
		
		await super._ready()

func active():
	var sphere = overall_spell.sphere
	ennemy_in_range = ServiceScenes.entities.ennemiesNode.filter(
		func(ennemy):
			return self.global_position.distance_to(ennemy.position) < RANGE_MAX
	)
	
	if ennemy_in_range.size() == 0:
		return
		
	var ennemy_to_shoot = ennemy_in_range[randi_range(0, ennemy_in_range.size() - 1)]
	var direction = (ennemy_to_shoot.position - sphere.position).normalized().rotated(deg_to_rad(randf_range(-5, 5)))
	self.position = sphere.position + (direction.normalized() * 30)
	self.rotation = direction.angle()

	self.show()
	for i in range(18):
		self.position += direction * speed
		await get_tree().create_timer(0).timeout
		
	self.hide()
