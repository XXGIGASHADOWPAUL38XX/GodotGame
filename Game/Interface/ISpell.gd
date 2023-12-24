extends Area2D
var service_time = preload("res://Game/Services/service_time.gd").new()
var collision_script = preload('res://Game/Services/ServiceCollision/collision.gd').new()

var func_on_entity_entered: Array[Callable]
var func_on_entity_exited: Array[Callable]

var player_hitted
var ennemies_in = []
var spells_retrigger = {}

var CONF_DETECT_WITH

func _ready():
	CONF_DETECT_WITH = ServiceScenes.allEnnemiesNode if CONF_DETECT_WITH == null else CONF_DETECT_WITH
	
	self.visibility_changed.connect(
		func(): self.get_node("CollisionShape2D").disabled = !self.visible
	)
	
	self.body_entered.connect(func(obj): 
		if CONF_DETECT_WITH.find(obj) != -1:
			ennemies_in.append(obj)
			entity_entered(obj)
	)
	self.body_exited.connect(func(obj): 
		if CONF_DETECT_WITH.find(obj) != -1:
			ennemies_in.remove_at(ennemies_in.find(obj))
			entity_exited(obj)
	)

func entity_entered(ennemy): #FAIRE LES DEGATS
	player_hitted = ennemy
	for fc in func_on_entity_entered:
		var node = fc.get_object()
		fc.call()
		
func entity_exited(ennemy):
	player_hitted = ennemy
	for fc in func_on_entity_exited:
		var node = fc.get_object()
		fc.call()
