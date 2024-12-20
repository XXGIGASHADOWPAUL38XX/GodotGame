extends Node

func map_item(item_name):
	return {
		"block_gem" : ServiceScenes.championNode,
		"boost_gem" : ServiceScenes.championNode,
		"cleanse_gem" : ServiceScenes.championNode,
		"drone_gem" : ServiceScenes.championNode,
		"earthquake_gem" : ServiceScenes.championNode,
		"mark_gem" : ServiceScenes.entities.ennemiesNode,
		"shockwave_gem" : ServiceScenes.championNode,
		"slice_gem" : ServiceScenes.championNode,
		
		"vision_square" : ServiceScenes.championNode,
		"vision_radar" : ServiceScenes.championNode,
	}[item_name.to_lower()]
	
func instanciate_item(item_name, path):
	Servrpc.any(self, "instanciate_item_rpc", [item_name, map_item(item_name), path.call(item_name)])

func instanciate_item_rpc(item_name, champions, path): 
	var item_scene = load(path).instantiate()
	
	if champions is Array:
		champions.map(func(e): 
			item_scene.set_multiplayer_authority(e.get_multiplayer_authority())
			e.add_child(item_scene)
		) 
		return 
		
	item_scene.set_multiplayer_authority(champions.get_multiplayer_authority()) 
	champions.add_child(item_scene)

