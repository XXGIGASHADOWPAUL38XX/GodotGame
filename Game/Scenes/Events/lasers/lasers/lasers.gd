extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_multiplayer_authority(Server.get_first_player_connected_id())
	if is_multiplayer_authority():
		#POUR QUE LA SCENE SOIT INSTANCIEE POUR TOUS LES JOUEURS (ATTENTE RPC)
		await get_tree().create_timer(0.05).timeout 
		
		for i in range(10):
			Servrpc.any(self, 'add_laser', [])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_laser():
	var laser = $laser.duplicate() as Area2D
	laser.set_name("laser_R" + str(self.get_children().filter(
		func(obj): return obj.name.begins_with('laser')
	).size()))
	laser.set_multiplayer_authority(Server.get_first_player_connected_id())
	
	self.add_child(laser)
	add_multiplayer_properties(laser)
	laser.show()

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
	
