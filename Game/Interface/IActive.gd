extends Area2D

class_name IActive

var service_time = preload("res://Game/Services/service_time.gd").new()

var multip_sync: MultiplayerSynchronizer
var multip_sync_path: NodePath = "./../MultiplayerSynchronizer"
var ignore_multiconf_debug = false

var spell_controller: IControllerKeyPressed
var spells_placeholder: IPlaceholderSpells

@export var champion: IEntity

func _ready():
	self.process_mode = Node.PROCESS_MODE_DISABLED
	
	spell_controller_f()
	spells_placeholder_f()
	
	# ----------------- RESSOURCE LOADER : ALL SPELLS (INCLUDE DUPLICATED) ----------------- #
	if spells_placeholder != null:
		await await_resource_loaded(func(): return spells_placeholder.spells_dependencies_ready)
	# ----------------- RESSOURCE LOADER : ALL SPELLS (INCLUDE DUPLICATED) ----------------- #
	
	
	# IMPORTANT, PERMET D'EVITER UN BUG OU LE SPELL DE DUPLICATION DE BASE EST 
	# SUPPRIME PENDANT LA FONCTION SUIVANTE, CE QUI CAUSE UNE ERREUR, ON NE DOIT
	# PAS DECLENCHER LA FONCTION SUIVANTE DANS CE CAS
	Servrpc.any(self, 'champion_hitting', [])

	if !ignore_multiconf_debug:
		Servrpc.any(self, 'set_multiplayer_properties', [])

		#multip_sync.replication_config.get_properties().filter(func(p): return get_prpty_name(p) == self.name).map(func(p): 
			#if !str(p).ends_with(":position"):
				#multip_sync.replication_config.property_set_replication_mode(p, SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
		#)
		
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

func spell_controller_f(node: Node = self):
	if node is IControllerKeyPressed:
		spell_controller = node
		return null
	if node.get_parent() != null && node.get_parent() != ServiceScenes.main_scene:
		return spell_controller_f(node.get_parent())
		
	return null
	
func spells_placeholder_f(node: Node = self):
	if node is IPlaceholderSpells:
		spells_placeholder = node
		return null
	if node.get_parent() != null && node.get_parent() != ServiceScenes.main_scene:
		return spells_placeholder_f(node.get_parent())
		
	return null
	
func champion_hitting(node: Node = self):
	if node is IEntity:
		champion = node
		return null
	if node.get_parent() != null:
		return champion_hitting(node.get_parent())
		
	return null

func await_resource_loaded(c: Callable, retry_timeout: float=0.05):
	while c.get_object() != null && !c.call():
		await c.get_object().get_tree().create_timer(retry_timeout).timeout

func get_prpty_name(input_string: String) -> String:
	var substrings = input_string.split("/", false)
	substrings = substrings[0].split(":", false)

	return substrings[0]
