extends Node

var collision_script = preload('res://Game/Services/ServiceCollision/collision.gd').new()
var service_time = preload("res://Game/Services/service_time.gd").new()

var spells_retrigger = {}

func checkCollisions(heros, spell, f: Callable):
	var key_spell_heros = heros.name + '_' + spell.name
	
	if spell.visible && (spells_retrigger.get(key_spell_heros) == null or spells_retrigger[
		key_spell_heros].time_left == 0) && checkCollision(heros, spell):
		
		var sp = collision_script.get_spell(spell.name)
		var obj = f.get_object()
		Servrpc.send_to_id(heros.get_multiplayer_authority(), obj, f.get_method(), f.get_bound_arguments())
		
		spells_retrigger[key_spell_heros] = service_time.init_timer(heros, sp.retrigger)
		spells_retrigger[key_spell_heros].start()
			
func checkCollision(heros, spell):
	var shape_spell = spell.get_node("CollisionShape2D") as CollisionShape2D
	
	return (heros.global_position.distance_to(shape_spell.global_position) < shape_spell.shape.radius * 2)	




