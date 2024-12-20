class_name Gem

var item_utils = GemUtils.new()

var name: String
var category: Array[GemUtils.GemCategory]
var sub_items: Array[Gem]
var damage_bonus_flat: float
var health_bonus_flat: float
var armor_bonus_flat: float
var desc: String

func _init(name: String, category: Array[GemUtils.GemCategory], sub_items: Array[Gem], 
			damage_bonus_flat: float, health_bonus_flat: float, armor_bonus_flat: float, desc: String) -> void:
	self.name = name
	self.category = category
	self.sub_items = sub_items
	self.damage_bonus_flat = damage_bonus_flat
	self.health_bonus_flat = health_bonus_flat
	self.armor_bonus_flat = armor_bonus_flat
	self.desc = desc

func get_list_by_category(categories):
	var keys_categories = categories.map(func(category):
		return GemUtils.GemCategory[category.to_upper()]
	)

	#return allGems.filter(func(obj):
		#return obj.category.any(func(c): return c in keys_categories)
	#).map(func(obj):
		#return obj.name.to_lower()
	#)
	
	return []
	


