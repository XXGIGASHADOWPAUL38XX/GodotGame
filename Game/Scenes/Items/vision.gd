extends IShopInterface

func _ready():
	# --------------------------------- OVERRIDE ISHOPINTERFACE --------------------------------- #
	item_active_scene_path = func(item_name): return "res://Game/Scenes/Vision/" + item_name + ".tscn"
	number_item_value = 1
	# --------------------------------- OVERRIDE ISHOPINTERFACE --------------------------------- #
	
	super._ready()
