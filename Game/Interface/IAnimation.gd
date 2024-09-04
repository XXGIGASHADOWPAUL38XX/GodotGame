extends AnimatedSprite2D

class_name IAnimation

var multip_sync: MultiplayerSynchronizer
var multip_sync_path: NodePath = "./../MultiplayerSynchronizer"
var ignore_multiconf_debug: bool = false

var spell_controller: Node
var immobile_while_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		if !ignore_multiconf_debug:
			spell_controller_f()
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

func spell_controller_f(node: Node = self):
	if node is IControllerKeyPressed:
		spell_controller = node
		return null
	if node.get_parent() != null && node.get_parent() != ServiceScenes.main_scene:
		return spell_controller_f(node.get_parent())
		
	return null

func can_active(opt_param1=null, opt_param2=null, opt_param3=null):
	if immobile_while_active:
		ServiceScenes.championNode.add_state(self, 'states_action', State.StateAction.CONCENTRATE)
		
	await self.callv('active', [opt_param1, opt_param2, opt_param3].filter(func(opt_param): return opt_param != null))
	if immobile_while_active:
		ServiceScenes.championNode.remove_state(self, 'states_action')

func _exit_tree():
	Servrpc.recently_freed_nodepaths.append(self.get_path())
