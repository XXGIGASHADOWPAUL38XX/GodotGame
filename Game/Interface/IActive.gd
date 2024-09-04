extends Area2D

class_name IActive

var service_time = ServiceTime.new()

var multip_sync: MultiplayerSynchronizer
var multip_sync_path: NodePath = "./../MultiplayerSynchronizer"
var ignore_multiconf_debug = false

var spell_controller: IControllerKeyPressed
var spells_placeholder: IPlaceholderSpells
var immobile_while_active: bool

var animation
var resource_awaiter = ResourceAwaiter.new()

@export var is_ready: bool = false
@export var champion: IEntity

func _ready():
	self.process_mode = Node.PROCESS_MODE_DISABLED
	self.z_index = 1
	animation = self.get_children().filter(func(c): return c is AnimatedSprite2D)[0]
	ServiceScenes.loading_game.actives.append(self)
	
	spell_controller_f()
	spells_placeholder_f()
	
	# ----------------- RESSOURCE LOADER : ALL SPELLS (INCLUDE DUPLICATED) ----------------- #
	if spells_placeholder != null:
		await resource_awaiter.await_resource_loaded(func(): return spells_placeholder.spells_dependencies_ready)
	# ----------------- RESSOURCE LOADER : ALL SPELLS (INCLUDE DUPLICATED) ----------------- #
	
	# IMPORTANT, PERMET D'EVITER UN BUG OU LE SPELL DE DUPLICATION DE BASE EST 
	# SUPPRIME PENDANT LA FONCTION SUIVANTE, CE QUI CAUSE UNE ERREUR, ON NE DOIT
	# PAS DECLENCHER LA FONCTION SUIVANTE DANS CE CAS
	
	Servrpc.any(self, 'champion_hitting', [])

	if !ignore_multiconf_debug:
		Servrpc.any(self, 'set_multiplayer_properties', [])

	self.process_mode = Node.PROCESS_MODE_INHERIT
	is_ready = true

func can_active(opt_param1=null, opt_param2=null, opt_param3=null):
	if immobile_while_active:
		champion.add_state(self, 'states_action', State.StateAction.CONCENTRATE)
		
	await self.callv('active', [opt_param1, opt_param2, opt_param3].filter(func(opt_param): return opt_param != null))
	if immobile_while_active:
		champion.remove_state(self, 'states_action')

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
	multip_sync.replication_config.add_property(self.name + ":is_ready")
	
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

func _exit_tree():
	Servrpc.recently_freed_nodepaths.append(self.get_path())
