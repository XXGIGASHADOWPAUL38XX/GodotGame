class_name ItemClass

var health_gem = Item.new('health_gem', [ItemCategory.DURABILITY], 0.0, 5.0, 0.0, "health_gem")
var attack_gem = Item.new('attack_gem', [ItemCategory.DAMAGE], 5.0, 0.0, 0.0, "attack_gem")
var armor_gem = Item.new('life_gem', [ItemCategory.DURABILITY], 0.0, 0.0, 5.0, "life_gem")
var speed_gem = Item.new('speed_gem', [ItemCategory.UTILITY], 0.0, 5.0, 0.0, "speed_gem")

var shockwave_gem = Item.new('shockwave_gem', [ItemCategory.DURABILITY], 0.0, 0.0, 0.0, 
				"Emet une vague de dêgats quand des dêgats sont recus")
var drone_gem = Item.new('drone_gem', [ItemCategory.DAMAGE], 
				0.0, 0.0, 0.0, "Invoque un drône tireur")
var slice_gem = Item.new('slice_gem', [ItemCategory.DAMAGE, ItemCategory.UTILITY], 
				0.0, 0.0, 0.0, "Occtroie une charge rapide effectuant des degats")
var earthquake_gem = Item.new('earthquake_gem', [ItemCategory.DURABILITY], 0.0, 0.0, 0.0, 
				"Créé un séisme infligant des dêgats autour de soi")
var block_gem = Item.new('block_gem', [ItemCategory.DURABILITY, ItemCategory.UTILITY], 0.0, 0.0, 0.0, 
				"Bloque les projectiles ennemis")
var boost_gem = Item.new('boost_gem', [ItemCategory.DURABILITY, ItemCategory.DAMAGE], 0.0, 0.0, 0.0, 
				"Augmente les stats temporairement à chaque coup donné")
var mark_gem = Item.new('mark_gem', [ItemCategory.DAMAGE], 0.0, 0.0, 0.0, 
				"Chaque sort met une marque à l'ennemi qui explode une fois stackée")
var cleanse_gem = Item.new('cleanse_gem', [ItemCategory.UTILITY], 0.0, 0.0, 0.0, 
				"Purge tous les contrôles")

var allItems = [shockwave_gem, drone_gem, slice_gem, earthquake_gem, block_gem, boost_gem, mark_gem, cleanse_gem]

class Item:
	var name: String
	var category: Array[ItemCategory]
	var damage_bonus_flat: float
	var health_bonus_flat: float
	var armor_bonus_flat: float
	var desc: String

	func _init(name: String, category: Array[ItemCategory], 
				damage_bonus_flat: float, health_bonus_flat: float, armor_bonus_flat: float, desc: String) -> void:
		self.name = name
		self.category = category
		self.damage_bonus_flat = damage_bonus_flat
		self.health_bonus_flat = health_bonus_flat
		self.armor_bonus_flat = armor_bonus_flat
		self.desc = desc

enum ItemCategory {
	DAMAGE,
	UTILITY,
	DURABILITY,
	NULL
}

func get_item(name):
	var item = get(name)
	if item is Item:
		return item
	else:
		return null

func get_list_by_category(categories):
	var keys_categories = categories.map(func(category):
		return ItemCategory[category.to_upper()]
	)

	return allItems.filter(func(obj):
		return obj.category.any(func(c): return c in keys_categories)
	).map(func(obj):
		return obj.name.to_lower()
	)
	


