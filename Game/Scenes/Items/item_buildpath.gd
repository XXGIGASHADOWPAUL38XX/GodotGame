extends IItems

var gem: Gem
var gem_and_subgems: Array[Gem]
var duplicator

# Called when the node enters the scene tree for the first time.
func _ready():
	await super._ready()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func post_dp_script(id, dp_number):
	duplicator = self.get_parent().get_node("dp_items")
	
	gem = duplicator.items[id - 1]
	self.name = gem.name
	item_actif.name = gem.name
	
	display()

func display():
	item_actif.texture_normal = load("res://Game/Ressources/Gems/" + gem.name + ".png")
	gem.sub_items.map(func(sub_gem): 
		var sub_gem_index = gem.sub_items.find(sub_gem)
		subitems_textureRects[sub_gem_index].name = sub_gem.name
		subitems_textureRects[sub_gem_index].texture = load("res://Game/Ressources/Gems/" + sub_gem.name + ".png")
	)
