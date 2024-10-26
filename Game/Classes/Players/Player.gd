class_name Player

var id: int
var db_id: int
var name: String
var team: Team
var node: Node2D
var nodePath: String

func _init(id: int, name: String, team: Team, node=null) -> void:
	self.id = id
	self.db_id = Server.current_dbplayer["id"]
	self.name = name
	self.team = team
	self.node = node
	self.nodePath = "res://Game/Scenes/" + name + "/"  + name + ".tscn"

func is_ally():
	return ServiceScenes.champion.team.id == self.team.id
