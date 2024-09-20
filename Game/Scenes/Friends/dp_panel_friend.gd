extends IDuplication

var friends
var player_controller = PlayerController.new()

var name_callable: Callable = func dp_callable_name(id):
	return dp_node.name + "_R" + str(id)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	ServiceScenes.loading_async.add_loading(self.name, "Chargement de la liste d'amis")
	duplication_performed.connect(func(): ServiceScenes.loading_async.remove_loading(self.name))
	
	friends = await player_controller.get_friends(Server.current_playerpeer["id"])
	
	# VALUES TO OVERRIDE #
	dp_number = friends.size()
	dp_callable_name = name_callable
	dp_node = get_parent().get_node("panel_friend")
	await super._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
