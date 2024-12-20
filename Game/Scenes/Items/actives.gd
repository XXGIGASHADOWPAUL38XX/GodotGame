extends IShopInterface

func _ready():
	# --------------------------------- OVERRIDE ISHOPINTERFACE --------------------------------- #
	item_active_scene_path = func(item_name): return "res://Game/Scenes/items_passive/" + item_name + ".tscn"
	number_item_value = 2
	# --------------------------------- OVERRIDE ISHOPINTERFACE --------------------------------- #
	
	super._ready()
