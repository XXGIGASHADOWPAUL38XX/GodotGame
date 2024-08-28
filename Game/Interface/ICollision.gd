extends IActive

class_name ICollision

var func_on_entity_entered: Array[Callable]
var func_on_entity_exited: Array[Callable]

var player_hitted
var ennemies_in = []
var spells_retrigger = {}

var CONF_DETECT_WITH
var class_spell = CSpell.new()

var COLLISION_ON_SPECIFIC_ANIM = false
var collision_specific_anim = 'damage'

@export var retrigger: bool = false
@export var retrigger_time: float
var retrigger_timer

@export var state_action: State.StateAction = State.StateAction.NULL
@export var state_duration: float = 1.0

func _ready():
	CONF_DETECT_WITH = ServiceScenes.allEnnemiesNode if CONF_DETECT_WITH == null else CONF_DETECT_WITH
	
	#!! - Faire fonctionner avec tous les noms
	await super._ready()
	gestion_collision()
	
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

func gestion_collision():
	var collision_shape = self.get_node("CollisionShape2D")
	
	if COLLISION_ON_SPECIFIC_ANIM:
		animation.animation_changed.connect(func(): collision_shape.disabled = (animation.animation != 'damage'))
		self.visibility_changed.connect(func(): if !self.visible: collision_shape.disabled = true)
	else:
		self.get_node("CollisionShape2D").disabled = !self.visible
		self.visibility_changed.connect(
			func(): self.call_deferred("set_collision_disabled", !self.visible)
		)
		
func set_collision_disabled(disabled: bool) -> void:
	self.get_node("CollisionShape2D").disabled = disabled

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

func set_multiplayer_properties():
	super.set_multiplayer_properties()
	multip_sync.replication_config.add_property(self.name + ":state_action")
	multip_sync.replication_config.add_property(self.name + ":state_duration")
		
	if retrigger:
		multip_sync.replication_config.add_property(self.name + ":retrigger")
		multip_sync.replication_config.add_property(self.name + ":retrigger_time")
