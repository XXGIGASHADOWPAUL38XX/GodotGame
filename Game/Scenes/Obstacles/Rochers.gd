extends CharacterBody2D

func _ready():
	ServiceScenes.rochers = self.get_children()
	for r in ServiceScenes.rochers:
		r.disabled = true
