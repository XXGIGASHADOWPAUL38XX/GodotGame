extends IDuplication

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_R" + str(id)
	
var vision_blue = Vision.new('vision_blue', [], "Parchemin de vision bleu")
var vision_red = Vision.new('vision_red', [], "Parchemin de vision rouge")
	
var subitems = [vision_blue, vision_red]
var items = [
	Vision.new('vision_square', 
		[vision_blue],
		"Obtient la vision sur un zone spécifiée"
	),
	Vision.new('vision_radar', 
		[vision_red], 
		"Détecte les entitées à proximité"
	),
]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.loading_async.add_loading(self.name + "vision", "Charvisionent des visions du shop")
	
	# VALUES TO OVERRIDE #
	dp_number = items.size()
	dp_callable_name = name_callable
	dp_node = get_parent().get_node("item_buildpath")
	await super._ready()
	
	duplication_performed.connect(func(): ServiceScenes.loading_async.remove_loading(self.name + "vision"))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
