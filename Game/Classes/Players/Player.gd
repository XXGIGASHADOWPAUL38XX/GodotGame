class_name Player

var id: int
var name: String
var team: Team
var node: Node2D

func _init(id: int, name: String, team: Team, node=null) -> void:
	self.id = id
	self.name = name
	self.team = team
	self.node = node

func is_ally():
	return ServiceScenes.champion.team.id == self.team.id
