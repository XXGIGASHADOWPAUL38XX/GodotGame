extends Node

var green_orb = Actif.new('green_orb', ActifCategory.DURABILITY,
	"Emet une vague de dêgats quand des dêgats sont recus")
var blue_orb = Actif.new('blue_orb',
			ActifCategory.DURABILITY, "Invoque un drône tireur")
var red_orb = Actif.new('red_orb',
			ActifCategory.DURABILITY, "Occtroie une charge rapide effectuant des degats")
var orange_orb = Actif.new('orange_orb', ActifCategory.DURABILITY, "JSP ENCORE")

var allActifs = [green_orb, blue_orb, red_orb, orange_orb]

class Actif:
	var name: String
	var category: ActifCategory
	var desc: String

	func _init(name: String, category: ActifCategory, 
				desc: String) -> void:
		self.name = name
		self.category = category
		self.desc = desc

enum ActifCategory {
	DAMAGE,
	FIGHT,
	DURABILITY,
}

func get_Actif(name):
	var Actif = get(name)
	if Actif is Actif:
		return Actif
	else:
		return null

func get_list_by_category(category: String):
	return allActifs.filter(func(obj):
		return obj.category == ActifCategory.get(category.to_upper())
	).map(func(obj):
		return obj.name
	)
	
func duplicate_Actif(Actif):
	var new_Actif = Actif.new(
		Actif.name, Actif.category, Actif.damage,
		Actif.health, Actif.armor, Actif.desc
	) 
	
	return new_Actif
	


