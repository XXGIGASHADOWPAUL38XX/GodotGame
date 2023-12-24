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

var mage_f = Hero.new(120, 15, 15, 80)
var warrior_m = Hero.new(130, 15, 15, 80)
var ranger_m = Hero.new(120, 15, 15, 80)
var ninja_m = Hero.new(120, 15, 15, 80)
var healer_f = Hero.new(120, 15, 15, 80)
var tank_m = Hero.new(140, 10, 20, 80)

var monster_gem = Hero.new(200, 15, 15, 0)

var boss_golem = Hero.new(300, 15, 15, 0)
var boss_crystal = Hero.new(300, 15, 15, 0)




