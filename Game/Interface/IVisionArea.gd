extends Area2D

class_name IVisionArea

@onready var collision_shape = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		area_entered.connect(Callable(self, 'entered_entity'))
		area_exited.connect(Callable(self, 'exited_entity'))
		
		body_entered.connect(Callable(self, 'entered_entity'))
		body_exited.connect(Callable(self, 'exited_entity'))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func entered_entity(entity):
	if ServiceScenes.championNode.placeholder_spells.all_actives == null or \
		entity in ServiceScenes.championNode.placeholder_spells.all_actives:
		return
		
	if entity is IEntity:
		entity.show()
	elif entity is IActive:
		entity.show()
	
func exited_entity(entity):
	if ServiceScenes.championNode.placeholder_spells.all_actives == null or \
		entity in ServiceScenes.championNode.placeholder_spells.all_actives:
		return
		
	if entity is IEntity:
		entity.hide()
	elif entity is IActive:
		entity.hide()
