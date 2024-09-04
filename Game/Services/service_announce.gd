extends Node

func set_announce(text, ressource_1, ressource_2, champion=null):
	Servrpc.any(self, 'set_announce_global', [text, ressource_1, ressource_2, champion])
	
func set_announce_global(text, ressource_1, ressource_2, champion):
	#var announcer_scene = preload("res://Game/Scenes/Announcer/announcer.tscn").instantiate()
	#ServiceScenes.getMainScene().add_child(announcer_scene)
	
	ServiceScenes.announcer_scene.set_announce(text, ressource_1, ressource_2, champion)
	
