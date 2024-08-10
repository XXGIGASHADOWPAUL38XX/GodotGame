extends CharacterBody2D

class_name IPhysicalSpell

var service_time = preload("res://Game/Services/service_time.gd").new()
var func_on_hit: Array[Callable] = []
var spells_placeholder

var player_hitted
var ennemies_in = []
var spells_retrigger = {}
var cshape

@export var damage_base: float
var output_damage = Callable(output_damage_f)

var multip_sync: MultiplayerSynchronizer
var multip_sync_path: NodePath = "./../MultiplayerSynchronizer"
var ignore_multiconf_debug: bool = false

var CONF_DETECT_WITH

func _ready():
	self.process_mode = Node.PROCESS_MODE_DISABLED
	CONF_DETECT_WITH = ServiceScenes.allEnnemiesNode if CONF_DETECT_WITH == null else CONF_DETECT_WITH
	self.visibility_changed.connect(func(): get_node('CollisionShape2D').disabled = !self.visible)
	
	#spell_controller_f()
	spells_placeholder_f()
	
	# ----------------- RESSOURCE LOADER : ALL SPELLS (INCLUDE DUPLICATED) ----------------- #
	if spells_placeholder != null:
		await await_resource_loaded(func(): return spells_placeholder.spells_dependencies_ready)
	# ----------------- RESSOURCE LOADER : ALL SPELLS (INCLUDE DUPLICATED) ----------------- #
		
	
	if !ignore_multiconf_debug:
		Servrpc.any(self, 'set_multiplayer_properties', [])
		
	self.process_mode = Node.PROCESS_MODE_INHERIT

func on_hit(ennemy): #FAIRE LES DEGATS
	player_hitted = ennemy
	for fc in func_on_hit:
		var node = fc.get_object()
		fc.call()

func output_damage_f(champion_hitted):
	return damage_base

# FONCTIONS SUR LES COLLISIONS 
func _on_body_entered(heros: Node2D):
	pass

func collision():
	for player in CONF_DETECT_WITH:
		if self.visible && player.visible && self.global_position.distance_to(player.position) < (cshape.shape.radius * 2):
			send_damage(player)

func send_damage(player):
	Servrpc.send_to_id(player.get_multiplayer_authority(), player, 'hitted', [self]) # heros hitted BY ennemy spell
	self.on_hit(player)


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
	
func await_resource_loaded(c: Callable, retry_timeout: float=0.05):
	while c.get_object() != null && !c.call():
		await c.get_object().get_tree().create_timer(retry_timeout).timeout
