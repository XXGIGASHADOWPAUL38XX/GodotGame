extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		#POUR QUE LA SCENE SOIT INSTANCIEE POUR TOUS LES JOUEURS (ATTENTE RPC)
		await get_tree().create_timer(0.05).timeout 
		
		for i in range(19):
			Servrpc.any(self, 'add_mine', [])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_mine():
	var mine = $mine.duplicate() as Area2D
	mine.set_name("mine_R" + str(self.get_children().filter(
		func(obj): return obj.name.begins_with('mine')
	).size()))
	mine.set_multiplayer_authority(Server.get_first_player_connected_id())
	add_multiplayer_properties(mine)
	
	self.add_child(mine)

func add_multiplayer_properties(duplicated_node: Node2D):
	var animation = duplicated_node.get_children().filter(
		func(obj): return obj.name.begins_with('anim')
	)[0]
	
	var MULTIPSYNC = $MutliplayerSynchronizer
	
	MULTIPSYNC.replication_config.add_property(duplicated_node.name + ":position")
	MULTIPSYNC.replication_config.add_property(duplicated_node.name + ":scale")
	MULTIPSYNC.replication_config.add_property(duplicated_node.name + ":visible")
	MULTIPSYNC.replication_config.add_property(duplicated_node.name + ":modulate")

	MULTIPSYNC.replication_config.add_property(duplicated_node.name + "/" + animation.name + ":animation")
	MULTIPSYNC.replication_config.add_property(duplicated_node.name + "/" + animation.name + ":frame")
	
