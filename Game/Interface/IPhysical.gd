extends CharacterBody2D

class_name IPhysical

var service_time = ServiceTime.new()
var resource_awaiter = ResourceAwaiter.new()

var spells_placeholder

var multip_sync: MultiplayerSynchronizer
var multip_sync_path: NodePath = "./../MultiplayerSynchronizer"
var ignore_multiconf_debug: bool = false

var animation

func _ready():
	self.process_mode = Node.PROCESS_MODE_DISABLED
	animation = self.get_children().filter(func(c): return c is AnimatedSprite2D)[0]
	
	#spell_controller_f()
	spells_placeholder_f()
	
	# ----------------- RESSOURCE LOADER : ALL SPELLS (INCLUDE DUPLICATED) ----------------- #
	if spells_placeholder != null:
		await resource_awaiter.await_resource_loaded(func(): return spells_placeholder.spells_dependencies_ready)
	# ----------------- RESSOURCE LOADER : ALL SPELLS (INCLUDE DUPLICATED) ----------------- #
		
	
	if !ignore_multiconf_debug:
		Servrpc.any(self, 'set_multiplayer_properties', [])
		
	self.process_mode = Node.PROCESS_MODE_INHERIT

func set_multiplayer_properties():
	var animation = self.get_children().filter(func(c): return c is AnimatedSprite2D)[0]
	var anim_path = self.name + "/" + animation.name
	
	multip_sync = self.get_node(multip_sync_path) as MultiplayerSynchronizer	
	multip_sync.replication_config.add_property(self.name + ":visible")
	multip_sync.replication_config.add_property(self.name + ":modulate")
	multip_sync.replication_config.add_property(self.name + ":rotation")
	multip_sync.replication_config.add_property(self.name + ":position")
	multip_sync.replication_config.add_property(self.name + ":scale")
	
	multip_sync.replication_config.add_property(anim_path + ":animation")
	multip_sync.replication_config.add_property(anim_path + ":frame")
	
	multip_sync.replication_config.add_property(self.name + ":damage_base")

func spells_placeholder_f(node: Node = self):
	if node is IPlaceholderSpells:
		spells_placeholder = node
		return null
	if node.get_parent() != null && node.get_parent() != ServiceScenes.main_scene:
		return spells_placeholder_f(node.get_parent())
		
	return null
