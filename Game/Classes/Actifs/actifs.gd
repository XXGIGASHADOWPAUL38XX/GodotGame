extends Node

var green_orb = Item.new('green_orb', ItemCategory.DURABILITY,
	"Emet une vague de dêgats quand des dêgats sont recus")
var blue_orb = Item.new('blue_orb',
			ItemCategory.DURABILITY, "Invoque un drône tireur")
var red_orb = Item.new('red_orb',
			ItemCategory.DURABILITY, "Occtroie une charge rapide effectuant des degats")
var orange_orb = Item.new('orange_orb', ItemCategory.DURABILITY, "JSP ENCORE")

var allItems = [green_orb, blue_orb, red_orb, orange_orb]

class Item:
	var name: String
	var category: ItemCategory
	var desc: String

	func _init(name: String, category: ItemCategory, 
				desc: String) -> void:
		self.name = name
		self.category = category
		self.desc = desc

enum ItemCategory {
	DAMAGE,
	FIGHT,
	DURABILITY,
}

func get_list_by_category(category: String):
	return allItems.filter(func(obj):
		return obj.category == ItemCategory.get(category.to_upper())
	).map(func(obj):
		return obj.name
	)

	


