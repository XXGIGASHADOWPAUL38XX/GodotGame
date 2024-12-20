extends IVisionArea

class_name IAnimableVisionArea

@onready var animation = $anim_vision_area

var multip_sync: MultiplayerSynchronizer
var multip_sync_path: NodePath = "./../MultiplayerSynchronizer"

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		await super._ready()
		Servrpc.any(self, 'set_multiplayer_properties', [])

func active():
	pass

func set_multiplayer_properties():
	if animation == null:
		animation = self.get_children().filter(func(c): return c is AnimatedSprite2D)[0]
	var anim_path = self.name + "/" + animation.name
	
	multip_sync = self.get_node(multip_sync_path) as MultiplayerSynchronizer

	if multip_sync.replication_config.has_property(self.name + ":visible"):
		multip_sync.replication_config.get_properties().map(func(prop):
			multip_sync.replication_config.remove_property(prop)
		)
	
	multip_sync.replication_config.add_property(self.name + ":visible")
	multip_sync.replication_config.add_property(self.name + ":modulate")
	multip_sync.replication_config.add_property(self.name + ":rotation")
	multip_sync.replication_config.add_property(self.name + ":position")
	multip_sync.replication_config.add_property(self.name + ":scale")
	
	multip_sync.replication_config.add_property(anim_path + ":animation")
	multip_sync.replication_config.add_property(anim_path + ":frame")
