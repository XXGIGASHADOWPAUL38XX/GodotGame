extends IItems

var vision: Vision
var vision_and_subvisions: Array[Vision]
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
	items_container.map(func(sub_vision): 
		var sub_vision_index = items_container.find(sub_vision)
		items_container[sub_vision_index].texture = load("res://Game/Ressources/Vision/" +
			vision.sub_visions[sub_vision_index].name + ".png"
		)
	)
