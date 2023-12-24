extends Node2D

var starter_point

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_multiplayer_authority(Server.get_first_player_connected_id())
	if is_multiplayer_authority():
		starter_point = $starter_point
		
		#POUR QUE LA SCENE SOIT INSTANCIEE POUR TOUS LES JOUEURS (ATTENTE RPC)
		await get_tree().create_timer(0.05).timeout 
		
		for i in range(ServiceScenes.rochers.size()):
			Servrpc.any(self, 'add_starter_point', [ServiceScenes.rochers[i].global_position])
		for i in range(1, 3 * 3): #ON COMMENCE A 1 POUR GARDER starter_point
			var x = (i % 3) * get_window().size.x
			var y = floor(i / 3) * get_window().size.y
			Servrpc.any(self, 'add_starter_point', [Vector2(x, y)])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_starter_point(position_spl: Vector2):
	var spl = $starter_point.duplicate()
	spl.global_position = position_spl
	spl.set_name("starter_point_" + str(self.get_children().size()))
	
	spl.show()
	self.add_child(spl)
	add_multiplayer_properties(spl)

func add_multiplayer_properties(duplicated_node: Node2D):
	var animation = duplicated_node.get_children().filter(
		func(obj): return obj.name.begins_with('anim')
	)[0]
	
	var MULTIPSYNC = $MSYNC
	
	MULTIPSYNC.replication_config.add_property(duplicated_node.name + ":position")
	MULTIPSYNC.replication_config.add_property(duplicated_node.name + ":rotation")
	MULTIPSYNC.replication_config.add_property(duplicated_node.name + ":visible")
#	MULTIPSYNC.replication_config.add_property(duplicated_node.name + ":modulate")
#
	MULTIPSYNC.replication_config.add_property(duplicated_node.name + "/" + animation.name + ":animation")
	MULTIPSYNC.replication_config.add_property(duplicated_node.name + "/" + animation.name + ":frame")
	
