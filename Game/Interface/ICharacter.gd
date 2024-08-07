extends IEntity

class_name ICharacter

var animation: AnimatedSprite2D

# STATS ------------
var damage_base
var armor_base
var health_base
var speed_base

var damage_bonus_flat = 0
var armor_bonus_flat = 0
var health_bonus_flat = 0
var speed_bonus_flat = 0

var damage_bonus_ratio = 1
var armor_bonus_ratio = 1
var health_bonus_ratio = 1
var speed_bonus_ratio = 1

@export var damage_final: float
@export var armor_final: float
@export var health_final: float
@export var speed_final: float

@export var state_movement: State.StateMovement = State.StateMovement.NULL
@export var state_damage: State.StateDamage = State.StateDamage.NULL
@export var state_shielded: State.StateShielded = State.StateShielded.NULL

var health_bar
var shield
var class_spell = CSpell.new()

func set_attribute(key, value, time=null):
	var old_value = self.get(key)
	self.set(key, value)
	
	if time:
		await get_tree().create_timer(time).timeout
		self.set(key, old_value)
		
func take_damage():
	var output_damage = last_spell_hitting.output_damage.call(self)
		
	if state_shielded == State.StateShielded.SHIELDED:
		output_damage = shield.remaining_damage(output_damage)
		
	self.health_bar.value -= output_damage
	
	ServiceAnimations.set_animation(self, 'animation_hitted')

	for i in range(2):
		self.animation.modulate = Color.RED
		await get_tree().create_timer(0.15).timeout
		self.animation.modulate = Color.WHITE
		await get_tree().create_timer(0.15).timeout

func _ready():
	health_bar = $health_bar
	func_hitted = [Callable(self, 'take_damage')]
	
	if is_multiplayer_authority():
		ServiceStats.set_attributes(self)
		self.new_round()

		await super._ready()
		
func new_round():
	health_bar.value = health_bar.max_value
	
func set_multiplayer_properties():
	super.set_multiplayer_properties()
	var hlth_bar_path = self.name + "/health_bar"
	
	multip_sync.replication_config.add_property(self.name + ":damage_final")
	multip_sync.replication_config.add_property(self.name + ":health_final")
	multip_sync.replication_config.add_property(self.name + ":armor_final")
	multip_sync.replication_config.add_property(self.name + ":speed_final")

	multip_sync.replication_config.add_property(hlth_bar_path + ":position")
	multip_sync.replication_config.add_property(hlth_bar_path + ":value")
	multip_sync.replication_config.add_property(hlth_bar_path + ":max_value")

func await_resource_loaded(c: Callable, retry_timeout: float=0.05):
	while c.get_object() != null && !c.call():
		await c.get_object().get_tree().create_timer(retry_timeout).timeout
		
	return true
