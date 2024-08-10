class Hero:
	var health: float
	var damage: float
	var armor: float
	var speed: float
	var spells: Array[CharacterBody2D]

	func _init(health: float, damage: float, armor: float, speed: float) -> void:
		self.health = health
		self.damage = damage
		self.armor = armor
		self.speed = speed
		self.spells = []

var mage_f = Hero.new(120, 15, 15, 3)
var warrior_m = Hero.new(130, 15, 15, 3)
var ranger_m = Hero.new(120, 15, 15, 3)
var ninja_m = Hero.new(120, 15, 15, 3)
var healer_f = Hero.new(120, 15, 15, 3)
var tank_m = Hero.new(140, 10, 20, 3)
var witcher_f = Hero.new(120, 15, 15, 3)
var bomber_f = Hero.new(120, 15, 15, 3)
var fighter_f = Hero.new(120, 15, 15, 3)

var monster_gem = Hero.new(200, 15, 15, 0)

var boss_golem = Hero.new(300, 15, 15, 0)
var boss_crystal = Hero.new(300, 15, 15, 0)

func get_heros(heros_name):
	var regex = RegEx.new()
	regex.compile("_R(\\d+)")
	var after_regex_name = regex.sub(heros_name, "")
	
	return get(after_regex_name)



