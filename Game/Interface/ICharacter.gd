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

## ------------------- GESTION DES STATES ------------------- ##

var states_action: Dictionary = {}
var states_damage: Dictionary = {}
var states_shielded: Dictionary = {}

var curr_state_action: SingleState = SingleState.new(State.StateAction.NULL, null):
	get:
		return curr_state_action
	set(value):
		curr_state_action = value
		if curr_state_action.state == State.StateAction.STUNNED:
			state_bar.init_state_bar(curr_state_action)
		
var curr_state_damage: SingleState = SingleState.new(State.StateDamage.NULL, null)
var curr_state_shielded: SingleState = SingleState.new(State.StateShielded.NULL, null)

## ------------------- ------------------ ------------------- ##

var health_bar
var shield
var state_bar

## ------------------- ------------------ ------------------- ##

func set_attribute(key, value, time=null):
	var old_value = self.get(key)
	self.set(key, value)
	
	if time:
		await get_tree().create_timer(time).timeout
		self.set(key, old_value)
		
func take_damage():
	var output_damage = last_spell_hitting.output_damage.call(self)
	if output_damage > 0 && last_spell_hitting.state_action != State.StateAction.NULL:
		set_state_action()
		
	if curr_state_shielded.state == State.StateShielded.SHIELDED:
		output_damage = shield.remaining_damage(output_damage)
		
	self.health_bar.value -= output_damage
	
	ServiceAnimations.set_animation(self, 'animation_hitted')

	for i in range(2):
		self.animation.modulate = Color.RED
		await get_tree().create_timer(0.15).timeout
		self.animation.modulate = Color.WHITE
		await get_tree().create_timer(0.15).timeout

func set_state_action():
	self.add_state(self, 'states_action', last_spell_hitting.state_action, last_spell_hitting.state_duration)

func _ready():
	health_bar = $pgbars/health_bar

	if is_multiplayer_authority():
		state_bar = $pgbars/state_bar
		ServiceStats.set_attributes(self)
		self.new_round()

		await super._ready()
		func_hitted.append(Callable(self, 'take_damage')) #!!
		
func new_round():
	health_bar.value = health_bar.max_value
	
func set_multiplayer_properties():
	super.set_multiplayer_properties()
	var hlth_bar_path = self.name + "/pgbars/health_bar"
	var state_bar_path = self.name + "/pgbars/state_bar"	
	
	multip_sync.replication_config.add_property(self.name + ":damage_final")
	multip_sync.replication_config.add_property(self.name + ":health_final")
	multip_sync.replication_config.add_property(self.name + ":armor_final")
	multip_sync.replication_config.add_property(self.name + ":speed_final")

	multip_sync.replication_config.add_property(hlth_bar_path + ":position")
	multip_sync.replication_config.add_property(hlth_bar_path + ":value")
	multip_sync.replication_config.add_property(hlth_bar_path + ":max_value")
	
	multip_sync.replication_config.add_property(state_bar_path + ":position")
	multip_sync.replication_config.add_property(state_bar_path + ":visible")
	multip_sync.replication_config.add_property(state_bar_path + ":value")
	multip_sync.replication_config.add_property(state_bar_path + ":max_value")

func await_resource_loaded(c: Callable, retry_timeout: float=0.05):
	while c.get_object() != null && !c.call():
		await c.get_object().get_tree().create_timer(retry_timeout).timeout

func add_state(origin, state_kind, state_value, state_duration=999):
	var dict_state_kind = self.get(state_kind)
	
	var state_timer = service_time.init_timer(self, state_duration)
	if state_duration != 999:
		state_timer.timeout.connect(func(): remove_state(origin, state_kind))
	state_timer.start()
	
	dict_state_kind[origin.name] = SingleState.new(state_value, state_timer)
	update_state(state_kind)

func remove_state(origin, state_kind):
	var dict_state_kind = self.get(state_kind)
	dict_state_kind.erase(origin.name)
	update_state(state_kind)
	
func remove_all_states(state_kind):
	var dict_state_kind = self.get(state_kind)
	dict_state_kind = {}
	update_state(state_kind)

func update_state(state_kind):
	var dict_state_kind = self.get(state_kind)
	var states = dict_state_kind.values()
	
	var current_state = {
		'states_action': 'curr_state_action',
		'states_damage': 'curr_state_damage',
		'states_shielded': 'curr_state_shielded'
	}
	
	if (states.size() == 0):
		self.set(current_state[state_kind], SingleState.new(State.StateAction.NULL, null))
	else:
		self.set(current_state[state_kind], states[0])
