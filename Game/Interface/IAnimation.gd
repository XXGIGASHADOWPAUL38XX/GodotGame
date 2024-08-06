extends AnimatedSprite2D

class_name IAnimation

var multip_sync: MultiplayerSynchronizer
var multip_sync_path: NodePath = "./../MultiplayerSynchronizer"
var ignore_multiconf_debug: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if !ignore_multiconf_debug:
		Servrpc.any(self, 'set_multiplayer_properties', [])

func set_multiplayer_properties():
	multip_sync = self.get_node(multip_sync_path)
	
	multip_sync.replication_config.add_property(self.name + ":visible")
	multip_sync.replication_config.add_property(self.name + ":modulate")
	multip_sync.replication_config.add_property(self.name + ":rotation")
	multip_sync.replication_config.add_property(self.name + ":position")
	multip_sync.replication_config.add_property(self.name + ":scale")
	multip_sync.replication_config.add_property(self.name + ":animation")
	multip_sync.replication_config.add_property(self.name + ":frame")
