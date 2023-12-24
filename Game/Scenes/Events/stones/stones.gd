extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_multiplayer_authority(Server.get_first_player_connected_id())
	if is_multiplayer_authority():
		#POUR QUE LA SCENE SOIT INSTANCIEE POUR TOUS LES JOUEURS (ATTENTE RPC)
		await get_tree().create_timer(0.05).timeout 
		
		for i in range(20):
			Servrpc.any(self, 'add_stone', [])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_stone():
	var stone = $stone.duplicate() as CharacterBody2D
	stone.set_name("stone_R" + str(self.get_children().filter(
		func(obj): return obj.name.begins_with('stone')
	).size()))
	stone.set_multiplayer_authority(Server.get_first_player_connected_id())
	
	self.add_child(stone)
	add_multiplayer_properties(stone)

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
	
