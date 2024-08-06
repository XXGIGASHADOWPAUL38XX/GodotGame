extends Node

var health_gem = Item.new('health_gem', ItemCategory.DURABILITY, 0.0, 5.0, 0.0, "health_gem")
var attack_gem = Item.new('attack_gem', ItemCategory.DURABILITY, 5.0, 0.0, 0.0, "attack_gem")
var armor_gem = Item.new('life_gem', ItemCategory.DURABILITY, 0.0, 0.0, 5.0, "life_gem")
var speed_gem = Item.new('speed_gem', ItemCategory.DURABILITY, 0.0, 5.0, 0.0, "speed_gem")

var shockwave_gem = Item.new('Shockwave', ItemCategory.DURABILITY, 0.0, 0.0, 0.0, 
	"Emet une vague de dêgats quand des dêgats sont recus")
var drone_gem = Item.new('Drone',
			ItemCategory.DURABILITY, 0.0, 0.0, 0.0, "Invoque un drône tireur")
var slice_gem = Item.new('Slice',
			ItemCategory.DURABILITY, 0.0, 0.0, 0.0, "Occtroie une charge rapide effectuant des degats")
var earthquake_gem = Item.new('Earthquake', ItemCategory.DURABILITY, 0.0, 0.0, 0.0, "JSP ENCORE")
var block_gem = Item.new('Block', ItemCategory.DURABILITY, 0.0, 0.0, 0.0, "JSP ENCORE")
var boost_gem = Item.new('Boost', ItemCategory.DURABILITY, 0.0, 0.0, 0.0, "JSP ENCORE")
var mark_gem = Item.new('Mark', ItemCategory.DURABILITY, 0.0, 0.0, 0.0, "JSP ENCORE")
var cleanse_gem = Item.new('Cleanse', ItemCategory.DURABILITY, 0.0, 0.0, 0.0, "JSP ENCORE")

var allItems = [shockwave_gem, drone_gem, slice_gem, earthquake_gem]

class Item:
	var name: String
	var category: ItemCategory
	var damage_bonus_flat: float
	var health_bonus_flat: float
	var armor_bonus_flat: float
	var desc: String

	func _init(name: String, category: ItemCategory, 
				damage_bonus_flat: float, health_bonus_flat: float, armor_bonus_flat: float, desc: String) -> void:
		self.name = name
		self.category = category
		self.damage_bonus_flat = damage_bonus_flat
		self.health_bonus_flat = health_bonus_flat
		self.armor_bonus_flat = armor_bonus_flat
		self.desc = desc

enum ItemCategory {
	DAMAGE,
	FIGHT,
	DURABILITY,
	NULL
}

func get_item(name):
	var item = get(name)
	if item is Item:
		return item
	else:
		return null

func get_list_by_category(category: String):
	return allItems.filter(func(obj):
		return obj.category == ItemCategory.get(category.to_upper())
	).map(func(obj):
		return obj.name
	)
	


