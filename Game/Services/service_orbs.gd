extends Node

func map_gem(orb_name):
	return {
		"block_gem" : ServiceScenes.championNode,
		"boost_gem" : ServiceScenes.championNode,
		"cleanse_gem" : ServiceScenes.championNode,
		"drone_gem" : ServiceScenes.championNode,
		"earthquake_gem" : ServiceScenes.championNode,
		"mark_gem" : ServiceScenes.ennemiesNode,
		"shockwave_gem" : ServiceScenes.championNode,
		"slice_gem" : ServiceScenes.championNode,
	}[orb_name.to_lower()]
	
func instanciate_orb(orb_name):
	Servrpc.any(self, "instanciate_orb_rpc", [orb_name, map_gem(orb_name)])

func instanciate_orb_rpc(orb_name, champions): 
	var orb_scene = load("res://Game/Scenes/Orbs/" + orb_name + ".tscn").instantiate()
	
	if champions is Array:
		champions.map(func(e): 
			orb_scene.set_multiplayer_authority(e.get_multiplayer_authority())
			e.add_child(orb_scene)
		) 
		return 
		
	orb_scene.set_multiplayer_authority(champions.get_multiplayer_authority()) 
	champions.add_child(orb_scene)

