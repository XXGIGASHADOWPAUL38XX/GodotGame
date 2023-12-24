extends "res://Game/Interface/IEntity.gd"

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

var damage_final
var armor_final
var health_final
var speed_final

var state_movement = State.StateMovement.NULL
var state_damage = State.StateDamage.NULL
var health_bar

func set_attribute(key, value, time=null):
	var old_value = self.get(key)
	self.set(key, value)
	
	if time:
		await get_tree().create_timer(time).timeout
		self.set(key, old_value)
		
func take_damage():
	if state_damage == State.StateDamage.IMMUNE:
		return
	var sp = collision_script.get_spell(last_spell_hitting.name)
	if last_spell_hitting.name.begins_with('spell'):
		self.health_bar.value -= sp.damage + (sp.damage_ratio * last_ennemy_hitting.damage_final) * (1 - (armor_final / 100))
	else:
		self.health_bar.value -= sp.damage * (1 - (armor_final / 100))
	ServiceAnimations.set_animation(self, 'animation_hitted')

	for i in range(2):
		self.animation.modulate = Color.RED
		await get_tree().create_timer(0.15).timeout
		self.animation.modulate = Color.WHITE
		await get_tree().create_timer(0.15).timeout

func _ready():
	health_bar = $health_bar
	if is_multiplayer_authority():
		func_hitted = [Callable(self, 'take_damage')]
		Servrpc.any(ServiceStats, 'set_attributes', [self])
		self.new_round()

func new_round():
	health_bar.value = health_bar.max_value
