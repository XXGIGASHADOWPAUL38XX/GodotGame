extends CharacterBody2D

func _ready():
	ServiceScenes.rochers = self.get_children()
