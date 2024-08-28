extends Node
var class_hero = preload("res://Game/Classes/Hero/Hero.gd").new()

var logos = {
	'health': preload("res://Game/Ressources/Stats/health.png"),
	'damage': preload("res://Game/Ressources/Stats/damage.png"),
	'armor': preload("res://Game/Ressources/Stats/armor.png"),
	'speed': preload("res://Game/Ressources/Stats/armor.png")
}

var colors = {
	'health': Color.GREEN,
	'damage': Color.RED,
	'armor': Color.GRAY,
	'speed': Color.ORANGE
}

func set_attributes(heros):
	var stats = class_hero.get_heros(heros.name)
	heros.set('damage_base', stats.get('damage'))
	heros.set('armor_base', stats.get('armor'))
	heros.set('health_base', stats.get('health'))
	heros.set('speed_base', stats.get('speed'))
	update_stats_final(heros)

	heros.health_bar.max_value = stats.health
	
func update_stats_local(heros, stat: String, value, update_mode=UpdateMode.UpdateMode.REPLACE):
	if update_mode == UpdateMode.UpdateMode.ADD:
		heros.set(stat, heros.get(stat) + value)
	else:
		heros.set(stat, value)
		
	update_stats_final(heros)
	
	var general_stat = stat.split('_')[0]
	ServiceText.display_text_local(general_stat, colors[general_stat], logos[general_stat])

func update_stats_final(heros):
	heros.damage_final = (heros.damage_base + heros.damage_bonus_flat) * heros.damage_bonus_ratio
	heros.armor_final = (heros.armor_base + heros.armor_bonus_flat) * heros.armor_bonus_ratio
	heros.health_final = (heros.health_base + heros.health_bonus_flat) * heros.health_bonus_ratio
	heros.speed_final = (heros.speed_base + heros.speed_bonus_flat) * heros.speed_bonus_ratio
	
	if ServiceScenes.HUD != null:
		ServiceScenes.HUD.get_stats()

func update_stats_from_item(heros, item):
	for property in item.get_property_list():
		if (property.type == TYPE_FLOAT && item.get(property.name) != 0.0):
			update_stats_local(heros, property.name, heros.get(property.name) + item.get(property.name))
