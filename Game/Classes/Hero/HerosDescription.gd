class_name HerosDescription

var name: String
var kind: HerosKind.Kind
var damage: int
var resistance: int
var mobility: int
var utility: int
var controls: int
var difficulty: int

func _init(name: String, kind: HerosKind.Kind, damage: int, resistance: int, utility: int, 
			mobility: int, controls: int, difficulty: int) -> void:
	self.name = name
	self.kind = kind
	self.damage = damage
	self.resistance = resistance
	self.mobility = mobility
	self.utility = utility
	self.controls = controls
	self.difficulty = difficulty

