extends PointLight2D

class_name IVision

var resource_awaiter = ResourceAwaiter.new()

var spells_placeholder

var multip_sync: MultiplayerSynchronizer
var multip_sync_path: NodePath = "./../MultiplayerSynchronizer"
var ignore_multiconf_debug: bool = false

var vision_area: Area2D

func _ready():
	self.process_mode = Node.PROCESS_MODE_DISABLED
	
	vision_area.collision_shape.disabled = !self.visible
	self.visibility_changed.connect(func():
		vision_area.collision_shape.disabled = !self.visible
	)
	
	spells_placeholder_f()
	
	# ----------------- RESSOURCE LOADER : ALL SPELLS (INCLUDE DUPLICATED) ----------------- #
	if spells_placeholder != null:
		await resource_awaiter.await_resource_loaded(func(): return spells_placeholder.spells_dependencies_ready)
	# ----------------- RESSOURCE LOADER : ALL SPELLS (INCLUDE DUPLICATED) ----------------- #
		
	if !ignore_multiconf_debug:
		self.set_multiplayer_properties()
		
	self.process_mode = Node.PROCESS_MODE_INHERIT

func set_multiplayer_properties():
	multip_sync = self.get_node(multip_sync_path) as MultiplayerSynchronizer	
	multip_sync.replication_config.add_property(self.name + ":visible")
	multip_sync.replication_config.add_property(self.name + ":modulate")
	multip_sync.replication_config.add_property(self.name + ":rotation")
	multip_sync.replication_config.add_property(self.name + ":position")
	multip_sync.replication_config.add_property(self.name + ":energy")
	multip_sync.replication_config.add_property(self.name + ":texture_scale") ##!!

func spells_placeholder_f(node: Node = self):
	if node is IPlaceholderSpells:
		spells_placeholder = node
		return null
	if node.get_parent() != null && node.get_parent() != ServiceScenes.main_scene:
		return spells_placeholder_f(node.get_parent())
		
	return null
