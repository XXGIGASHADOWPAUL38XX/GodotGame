extends CharacterBody2D

var func_hitted: Array[Callable] = []
var func_hit: Array[Callable] = []

var service_time = preload("res://Game/Services/service_time.gd").new()
var collision_script = preload("res://Game/Services/ServiceCollision/collision.gd").new()
var class_hero = preload("res://Game/Classes/Hero/Hero.gd").new()

var last_ennemy_hitting
var last_spell_hitting

func hitted(spell):
	last_spell_hitting = spell
	last_ennemy_hitting = spell.get_parent().get_parent()
	
	for fc in func_hitted:
		fc.call()

func hit(ennemy): #FAIRE LES DEGATS
	last_ennemy_hitting = ennemy
	for fc in func_hit:
		var node = fc.get_object()
		fc.call()








