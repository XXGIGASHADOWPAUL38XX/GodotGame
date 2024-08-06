extends Node

class_name CSpell

var spells_ranger_m_1 = Spell.new(9.0, 0.25, State.StateMovement.NULL, 3)
var spells_ranger_m_1_2 = Spell.new(9.0, 0.25, State.StateMovement.NULL, 3)
var spells_ranger_m_1_3 = Spell.new(9.0, 0.25, State.StateMovement.NULL, 3)
var spells_ranger_m_3 = Spell.new(6.0, 0.2, State.StateMovement.NULL, 0.3)
var spells_ranger_m_4 = Spell.new(8.0, 0.3, State.StateMovement.NULL, 1.0)

var spells_ninja_m_1 = Spell.new(10.0, 0.25, State.StateMovement.NULL, 3)
var spells_ninja_m_2 = Spell.new(9.0, 0.25, State.StateMovement.NULL, 3)
var spells_ninja_m_3 = Spell.new(4.0, 0.2, State.StateMovement.NULL, 0.1)
var spells_ninja_m_4_1 = Spell.new(10.0, 0.3, State.StateMovement.NULL, 1.0)
var spells_ninja_m_4_2 = Spell.new(10.0, 0.3, State.StateMovement.NULL, 1.0)
var spells_ninja_m_4_3 = Spell.new(10.0, 0.3, State.StateMovement.NULL, 1.0)

var spells_healer_f_1 = Spell.new(6.0, 0.15, State.StateMovement.NULL, 0.5)
var spells_healer_f_2 = Spell.new(-2.0, 0.05, State.StateMovement.NULL, 0.33)
var spells_healer_f_4 = Spell.new(-8.0, 0.2, State.StateMovement.SLOWED, 5)
var spells_healer_f_4_ally = Spell.new(-8.0, 0.2, State.StateMovement.SLOWED, 5)
var spells_healer_f_4_ennemy_1 = Spell.new(8.0, 0.2, State.StateMovement.SLOWED, 5)
var spells_healer_f_4_ennemy_2 = Spell.new(8.0, 0.2, State.StateMovement.SLOWED, 5)

var spells_tank_m_1 = Spell.new(6.0, 0.10, State.StateMovement.NULL, 5)
var spells_tank_m_2 = Spell.new(1.0, 0.02, State.StateMovement.NULL, 0.1)
var spells_exp_tank_m_3 = Spell.new(8.0, 0.12, State.StateMovement.STUNNED, 0.5)
var spells_tank_m_4 = Spell.new(8.0, 0.12, State.StateMovement.NULL, 5)

var explosion = Spell.new(10.0, 0.0, State.StateMovement.NULL, 2.0)

var health_gem = Spell.new(-5.00, 0.0, State.StateMovement.NULL, 1.0)

var blue_orb_p_missile = Spell.new(4.0, 0.0, State.StateMovement.NULL, 2.0)
var green_orb_passive = Spell.new(6.0, 0.0, State.StateMovement.NULL, 5.0)

var red_orb_active = Spell.new(6.0, 0.0, State.StateMovement.NULL, 5.0)
var green_orb_active = Spell.new(2.0, 0.0, State.StateMovement.NULL, 0.5)

var attack_golem = Spell.new(6.0, 0.0, State.StateMovement.NULL, 1.0)
var attack_crystal = Spell.new(6.0, 0.0, State.StateMovement.NULL, 1.0)
var attack_mg = Spell.new(6.0, 0.0, State.StateMovement.NULL, 1.0)

var red_spirit = Spell.new(5.0, 0.0, State.StateMovement.NULL, 1.0)
var green_spirit = Spell.new(-3.0, 0.0, State.StateMovement.NULL, 1.0)

var mine = Spell.new(5.0, 0.0, State.StateMovement.NULL, 1.0)

var stone = Spell.new(5.0, 0.0, State.StateMovement.NULL, 1.0)

var laser = Spell.new(10.0, 0.0, State.StateMovement.NULL, 1.0)

class Spell:
	var damage: float
	var damage_ratio: float
	var state_movement: State.StateMovement
	var retrigger: float
	
	func _init(damage, damage_ratio, state_movement, retrigger, after_retrg_ratio = 1):
		self.damage = damage
		self.damage_ratio = damage_ratio
		self.state_movement = state_movement
		self.retrigger = retrigger

func get_spell(spell_name):
	var regex = RegEx.new()
	regex.compile("_R(\\d+)")
	var after_regex_name = regex.sub(spell_name, "")
	
	return get(after_regex_name)

