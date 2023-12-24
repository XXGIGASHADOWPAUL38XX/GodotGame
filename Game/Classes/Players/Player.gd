class Player:
	var id: int
	var name: String
	var is_ally: bool
	var node: Node2D
	var spells = []

	func _init(id: int, name: String, is_ally: bool, node=null, spells=[]) -> void:
		self.id = id
		self.name = name
		self.is_ally = is_ally
		self.node = node
		self.spells = spells


