extends IItems

var vision: Vision
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
	
	vision = duplicator.items[id - 1]
	self.name = vision.name
	item_actif.name = vision.name
	
	display()

func display():
	item_actif.texture_normal = load("res://Game/Ressources/Vision/" + vision.name + ".png")
	vision.sub_items.map(func(sub_vision): 
		var sub_vision_index = vision.sub_items.find(sub_vision)
		subitems_textureRects[sub_vision_index].name = sub_vision.name
		subitems_textureRects[sub_vision_index].texture = load("res://Game/Ressources/Vision/" + sub_vision.name + ".png")
	)
