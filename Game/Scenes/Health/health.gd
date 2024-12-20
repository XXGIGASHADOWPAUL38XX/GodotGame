extends Control

var health_bar
var shield
var attached_entity

func _ready():
	if is_multiplayer_authority():
		attached_entity = attached_entity_f()
		health_bar = $health_bar
		shield = $shield
		
		attached_entity.visibility_changed.connect(func():
			self.visible = attached_entity.visible
		)

func _process(_delta):
	pass

func attached_entity_f(node=self):
	if node is IEntity:
		return node
	else:
		return attached_entity_f(node.get_parent())
		
	return null
